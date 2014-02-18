require 'patch/integer'
require 's3_swf_upload/signature'
require 's3_swf_upload/s3_config'
require 's3_swf_upload/view_helpers'

module S3SwfUpload
  # Rails 3 Railties!
  # https://gist.github.com/af7e572c2dc973add221
  require 's3_swf_upload/railtie' if defined?(Rails)
end
