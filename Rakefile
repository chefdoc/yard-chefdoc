require 'bundler/setup'
require 'rubygems/tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

Gem::Tasks.new

RSpec::Core::RakeTask.new(:spec, %i[tag trigger]) do |t|
  t.rspec_opts = '--format d'
end

task default: %i[rubocop spec]

desc 'Generate yard documentation of all test cookbook'
task :doc_files do
  FileList.new('test/fixtures/*').each do |cb|
    FileUtils.cd(cb) do
      sh 'bundle exec yardoc --plugin chefdoc "**/*.{rb,json}"'
    end
  end
end

desc 'Create test docs'
task :doc_server do
  FileList.new('test/fixtures/*').each do |cb|
    FileUtils.cd(cb) do
      sh 'rm -rf .yardoc doc'
      sh 'bundle exec yardoc --safe --plugin chefdoc --debug "**/*.{rb,json}"'
      sh 'bundle exec yard server --plugin chefdoc --debug'
    end
  end
end
