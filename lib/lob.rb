require 'fog'
require 'rake'

module Lob
  class Uploader
    def verify_env_and_upload(directory)
      verify_env_variables
      upload directory
    end

    def upload(directory)
      directory_content(directory).each do |file, value|
        create_file_or_directory(file, value)
      end
    end

    def directory_content(directory)
      return FileList["#{directory}/**/*"].inject({}) do |hash, path|
        if File.directory? path
          hash.update("#{path}/" => :directory)
        else
          hash.update(path => File.read(path))
        end
      end
    end

    def bucket
      @bucket ||= s3.directories.create(key: fog_directory, public: true)
    end

    def create_file_or_directory(file_or_directory, directory_flag)
      if directory_flag == :directory
        create_directory file_or_directory
      else
        create_file file_or_directory
      end
    end

    def create_directory(directory)
      bucket.files.create(key: directory, public: true)
    end

    def create_file(file)
      bucket.files.create(key: file, public: true, body: File.open(file))
    end

    def s3
      @s3 ||= Fog::Storage.new(
        provider: :aws,
        aws_access_key_id: aws_access_key,
        aws_secret_access_key: aws_secret_key
      )
    end

    def verify_env_variables
      required_env_variables.each do |env_variable|
        unless ENV[env_variable]
          puts "#{env_variable} required"
          exit 1
        end
      end
    end

    def required_env_variables
      ['AWS_ACCESS_KEY', 'AWS_SECRET_KEY', 'FOG_DIRECTORY']
    end

    def aws_access_key
      ENV['AWS_ACCESS_KEY']
    end

    def aws_secret_key
      ENV['AWS_SECRET_KEY']
    end

    def fog_directory
      ENV['FOG_DIRECTORY']
    end
  end

  @uploader = Uploader.new

  def upload(directory)
    @uploader.verify_env_and_upload(directory)
  end
end
