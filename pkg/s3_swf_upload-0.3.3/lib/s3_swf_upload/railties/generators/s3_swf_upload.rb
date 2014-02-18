require 'rails/generators/base'
 
module S3SwfUpload
  module Generators
    class Base < Rails::Generators::Base #:nodoc:
      
      def self.source_root
        # puts '****'
        # puts File.expand_path(File.join(File.dirname(__FILE__), generator_name, 'templates'))
        File.expand_path(File.join(File.dirname(__FILE__),generator_name, 'templates'))
      end
 
      def self.banner
        "#{$0} generate s3_swf_upload:#{generator_name} #{self.arguments.map{ |a| a.usage }.join(' ')}"
      end
      
    end
  end
end