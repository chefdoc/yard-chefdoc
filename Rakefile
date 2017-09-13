require 'bundler/setup'
require 'rubygems/tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

desc 'Create test docs'
task :doc_fixtures do
  FileList.new('test/fixtures/*').each do |cb|
    FileUtils.cd(cb) do
      sh 'rm -rf .yardoc doc'
      sh 'bundle exec yardoc --safe --plugin chefdoc --debug "**/*.{rb,json}"'
      sh 'bundle exec yard server --plugin chefdoc --debug'
    end
  end
end

Gem::Tasks.new

RSpec::Core::RakeTask.new(:spec, %i[tag trigger] => ['gen_yardoc'])

desc 'Generate yard documentation of all test cookbook'
task :gen_yardoc do
  FileList.new('test/fixtures/*').each do |cb|
    FileUtils.cd(cb) do
      sh 'bundle exec yardoc --debug --plugin chefdoc "**/*.{rb,json}"'
    end
  end
end
