# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name              = "s3_swf_upload"
  s.rubyforge_project = "s3_swf_upload"
  s.version           = "0.3.2"
  s.rubygems_version  = "1.3.6"
  s.date              = "2010-11-16"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors       = ["Nathan Colgate"]
  s.email         = "nathan@brandnewbox.com"
  s.homepage      = "https://github.com/nathancolgate/s3-swf-upload-plugin"
  s.description   = "Rails 3 gem that allows you to upload files directly to S3 from your application using flex for file management, css for presentation, and javascript for behavior."
  s.summary       = "Rails 3 gem that allows you to upload files directly to S3 from your application using flex for file management, css for presentation, and javascript for behavior."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options  = ["--line-numbers", "--inline-source", "--title", "S3_swf_upload", "--main", "README.textile"]
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    # if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0')
  end
end
