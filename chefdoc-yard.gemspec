Gem::Specification.new do |s|
  s.name        = 'yard-chefdoc'
  s.version     = '0.0.1'
  s.licenses    = 'MIT'
  s.summary     = 'A ruby yard extension for docuementing Chef cookbooks'
  s.authors     = 'Jörg Herzinger'
  s.email       = 'joerg.herzinger+chefdoc@oiml.at'
  s.files       = Dir['Rakefile',
                      'README.md',
                      'LICENSE',
                      '{lib,templates}/**/*']

  s.homepage    = 'https://github.com/chefdoc/yard-chefdoc'

  s.add_dependency('yard')
end
