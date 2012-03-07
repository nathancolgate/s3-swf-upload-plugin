module S3SwfUpload
  class S3Config
    require 'erb' unless defined?(ERB)
    require 'yaml' unless defined?(YAML)

    cattr_reader :access_key_id, :secret_access_key
    cattr_accessor :bucket, :max_file_size, :acl

    def self.load_config
      begin
        filename = "#{Rails.root}/config/amazon_s3.yml"

        buf = IO.read(filename)
        expanded = ERB.new(buf).result(binding)
        config = YAML.load(expanded)[Rails.env]

        if config == nil
          raise "Could not load config options for #{Rails.env} from #{filename}."
        end

        @@access_key_id     = config['access_key_id'] || ENV['AWS_ACCESS_KEY_ID']
        @@secret_access_key = config['secret_access_key'] || ENV['AWS_SECRET_ACCESS_KEY']
        @@bucket            = config['bucket']
        @@max_file_size     = config['max_file_size']
        @@acl               = config['acl'] || 'private'

        
        
        unless @@access_key_id && @@secret_access_key && @@bucket
          raise "Please configure your S3 settings in #{filename} before continuing so that S3 SWF Upload can function properly."
        end
      rescue Errno::ENOENT
         # Using put inside a rake task may mess with some rake tasks
         # According to: https://github.com/mhodgson/s3-swf-upload-plugin/commit/f5cc849e1d8b43c1f0d30eb92b772c10c9e73891
         # Going to comment this out for the time being
         # NCC@BNB - 11/16/10
         # No config file yet. Not a big deal. Just issue a warning
         # puts "WARNING: You are using the S3 SWF Uploader gem, which wants a config file at #{filename}, " +
         #    "but none could be found. You should try running 'rails generate s3_swf_upload:uploader'"
      end
    end
  end
end
