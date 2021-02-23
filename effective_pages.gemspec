$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'effective_pages/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'effective_pages'
  s.version     = EffectivePages::VERSION
  s.authors     = ['Code and Effect']
  s.email       = ['info@codeandeffect.com']
  s.homepage    = 'https://github.com/code-and-effect/effective_pages'
  s.summary     = 'Content pages for your rails app'
  s.description = 'Content pages for your rails app'
  s.licenses    = ['MIT']

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'README.md']

  s.add_dependency 'rails', '>= 6'
  s.add_dependency 'effective_datatables', '>= 4.0.0'
  s.add_dependency 'effective_resources'
  s.add_dependency 'effective_roles'
end
