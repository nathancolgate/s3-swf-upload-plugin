require 's3_swf_upload/railties/generators/s3_swf_upload'

module S3SwfUpload
  module Generators
    class UploaderGenerator < Base
      
      def create_uploader
        copy_file 'amazon_s3.yml', File.join('config','amazon_s3.yml')
        copy_file 's3_uploads_controller.rb', File.join('app','controllers', 's3_uploads_controller.rb')
        copy_file 's3_upload.js', File.join('public','javascripts', 's3_upload.js')
        copy_file 's3_upload.swf', File.join('public','flash', 's3_upload.swf')
        copy_file 's3_up_button.gif', File.join('public','flash', 's3_up_button.gif')
        copy_file 's3_down_button.gif', File.join('public','flash', 's3_down_button.gif')
        copy_file 's3_over_button.gif', File.join('public','flash', 's3_over_button.gif')
        route "resources :s3_uploads"
      end

    end
  end
end