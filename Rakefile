require "bundler/gem_tasks"
require "bundler/setup"
require "rake/testtask"
include Rake::DSL

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default do
  Rake::Task[:test].invoke
end
