require File.expand_path('../lib/yard-chefdoc/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'yard-chefdoc'
  s.version       = YARD::CodeObjects::Chef::VERSION
  s.license       = 'MIT'
  s.date          = Time.now.strftime('%Y-%m-%d')
  s.summary       = 'A ruby yard extension for docuementing Chef cookbooks'
  s.author        = 'Jörg Herzinger'
  s.email         = 'joerg.herzinger+chefdoc@oiml.at'
  s.files         = Dir.glob('{lib,spec,templates}/**/*') +
                    ['Rakefile', 'README.md', 'LICENSE', 'Gemfile']
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/chefdoc/yard-chefdoc'

  s.add_dependency('yard', '~> 0.9.9')
end
