$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "effective_pages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "effective_pages"
  s.version     = EffectivePages::VERSION
  s.authors     = ["Code and Effect"]
  s.email       = ["info@codeandeffect.com"]
  s.homepage    = "https://github.com/code-and-effect/effective_pages"
  s.summary     = "Content pages, bootstrap3 menu builder and page-specific header tag helpers for your Rails app."
  s.description = "Content pages, bootstrap3 menu builder and page-specific header tag helpers for your Rails app."
  s.licenses    = ['MIT']

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", [">= 3.2.0"]
  s.add_dependency "haml"
  s.add_dependency "sass-rails"
  s.add_dependency "migrant"
  s.add_dependency "simple_form"
  s.add_dependency "effective_slugs", '>= 1.1.0'
  s.add_dependency "effective_ckeditor", '>= 1.2.1'
  s.add_dependency "effective_regions", '>= 1.2.0'

  # s.add_development_dependency "sqlite3"

  # s.add_development_dependency "factory_girl_rails"
  # s.add_development_dependency "rspec-rails"
  # s.add_development_dependency "shoulda-matchers"
  # s.add_development_dependency "capybara"
  # s.add_development_dependency "poltergeist"

  # s.add_development_dependency "guard"
  # s.add_development_dependency "guard-rspec"
  # s.add_development_dependency "guard-livereload"

end
