# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{s3_swf_upload}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Colgate"]
  s.date = %q{2010-11-16}
  s.description = %q{Rails 3 gem that allows you to upload files directly to S3 from your application using flex for file management, css for presentation, and javascript for behavior.}
  s.email = %q{nathan@brandnewbox.com}
  s.extra_rdoc_files = ["CHANGELOG", "README.textile", "lib/patch/integer.rb", "lib/s3_swf_upload.rb", "lib/s3_swf_upload/railtie.rb", "lib/s3_swf_upload/railties/generators/s3_swf_upload.rb", "lib/s3_swf_upload/railties/generators/uploader/USAGE", "lib/s3_swf_upload/railties/generators/uploader/templates/amazon_s3.yml", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_down_button.gif", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_over_button.gif", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_up_button.gif", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_upload.js", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_upload.swf", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_uploads_controller.rb", "lib/s3_swf_upload/railties/generators/uploader/uploader_generator.rb", "lib/s3_swf_upload/railties/tasks/crossdomain.xml", "lib/s3_swf_upload/s3_config.rb", "lib/s3_swf_upload/signature.rb", "lib/s3_swf_upload/view_helpers.rb"]
  s.files = ["CHANGELOG", "MIT-LICENSE", "Manifest", "README.textile", "Rakefile", "flex_src/bin-release/flex-config.xml", "flex_src/compile", "flex_src/src/Globals.as", "flex_src/src/S3Uploader.as", "flex_src/src/com/adobe/net/MimeTypeMap.as", "flex_src/src/com/elctech/S3UploadOptions.as", "flex_src/src/com/elctech/S3UploadRequest.as", "flex_src/src/com/nathancolgate/s3_swf_upload/BrowseButton.as", "flex_src/src/com/nathancolgate/s3_swf_upload/S3Queue.as", "flex_src/src/com/nathancolgate/s3_swf_upload/S3Signature.as", "flex_src/src/com/nathancolgate/s3_swf_upload/S3Upload.as", "lib/patch/integer.rb", "lib/s3_swf_upload.rb", "lib/s3_swf_upload/railtie.rb", "lib/s3_swf_upload/railties/generators/s3_swf_upload.rb", "lib/s3_swf_upload/railties/generators/uploader/USAGE", "lib/s3_swf_upload/railties/generators/uploader/templates/amazon_s3.yml", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_down_button.gif", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_over_button.gif", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_up_button.gif", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_upload.js", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_upload.swf", "lib/s3_swf_upload/railties/generators/uploader/templates/s3_uploads_controller.rb", "lib/s3_swf_upload/railties/generators/uploader/uploader_generator.rb", "lib/s3_swf_upload/railties/tasks/crossdomain.xml", "lib/s3_swf_upload/s3_config.rb", "lib/s3_swf_upload/signature.rb", "lib/s3_swf_upload/view_helpers.rb", "s3_swf_upload.gemspec"]
  s.homepage = %q{http://github.com/nathancolgate/s3-swf-upload-plugin}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "S3_swf_upload", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{s3_swf_upload}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Rails 3 gem that allows you to upload files directly to S3 from your application using flex for file management, css for presentation, and javascript for behavior.}

  s.add_dependency('aws-s3', '~> 0.6.2')

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
