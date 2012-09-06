require 'base64'

class S3UploadsController < ApplicationController

  # You might want to look at https and expiration_date below.
  #        Possibly these should also be configurable from S3Config...

  skip_before_filter :verify_authenticity_token
  include S3SwfUpload::Signature
  
  def index
    bucket              = S3SwfUpload::S3Config.bucket
    access_key_id       = S3SwfUpload::S3Config.access_key_id
    acl                 = S3SwfUpload::S3Config.acl
    secret_key          = S3SwfUpload::S3Config.secret_access_key
    max_file_size       = S3SwfUpload::S3Config.max_file_size
    key                 = params[:key]
    content_type        = params[:content_type]
    content_disposition = 'attachment'
    https               = 'false'
    error_message       = ''
    expiration_date     = 1.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')

    policy = Base64.encode64(
"{
    'expiration': '#{expiration_date}',
    'conditions': [
        {'bucket': '#{bucket}'},
        {'key': '#{key}'},
        {'acl': '#{acl}'},
        {'Content-Type': '#{content_type}'},
        {'Content-Disposition': '#{content_disposition}'},
        ['content-length-range', 1, #{max_file_size}],
        ['starts-with', '$Filename', ''],
        ['eq', '$success_action_status', '201']
    ]
}").gsub(/\n|\r/, '')

    signature = b64_hmac_sha1(secret_key, policy)

    respond_to do |format|
      format.xml {
        render :xml => {
          :policy              => policy,
          :signature           => signature,
          :bucket              => bucket,
          :accesskeyid         => access_key_id,
          :acl                 => acl,
          :expirationdate      => expiration_date,
          :https               => https,
          :contentDisposition  => content_disposition,
          :errorMessage        => error_message.to_s
        }.to_xml
      }
    end
  end
end
