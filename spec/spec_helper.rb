require 'rspec'
require 'rspec-html-matchers'
require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'

require 'yard'
require_relative '../lib/yard-chefdoc'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include RSpecHtmlMatchers
end

# disable :run
# From: https://github.com/lsegal/yard/blob/master/lib/yard/cli/server.rb#L50
doc_root = File.expand_path('../../test/fixtures/test-cookbook1', __FILE__)
server_options = {
  Port: 8808
}
db = File.expand_path('.yardoc', doc_root)
libver = YARD::Server::LibraryVersion.new('test-cookbook1', nil, db)
libver.source_path = doc_root
libraries = {
  'test-cookbook1' => [libver]
}
options = SymbolHash.new(false).update(single_library: true, caching: false)
Capybara.app = YARD::Server::RackAdapter.new(libraries, options, server_options)
