# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "s3_swf_upload"
  gem.homepage = "http://github.com/nathancolgate/s3-swf-upload-plugin"
  gem.license = "MIT"
  gem.summary = %Q{Rails 3 gem that allows you to upload files directly to S3 from your application using flex for file management, css for presentation, and javascript for behavior.}
  gem.description = %Q{Rails 3 gem that allows you to upload files directly to S3 from your application using flex for file management, css for presentation, and javascript for behavior.}
  gem.email = "nathan@brandnewbox.com"
  gem.authors = ["Nathan Colgate"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "s3_swf_upload #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
