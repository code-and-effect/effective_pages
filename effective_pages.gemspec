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
  s.summary     = "A drop-in CMS solution for dynamically creating pages based off pre-defined templates.  Create templates ahead of time (think one_column, two_column..) with defined editable content regions.  Users can create content pages, choose a template, and use the fullscreen in-place editor to set their content."
  s.description = "A full solution for creating, updating and templating content pages in your Rails application. Write templates that define content regions. Use the full-page on-screen editor (effective_mercury) to edit content regions. While not required, the intended use of this gem includes ActiveAdmin (for the CRUD screens)"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "effective_mercury"
  s.add_dependency "effective_slugs"
  s.add_dependency "coffee-rails"
  s.add_dependency "formtastic"
  s.add_dependency "haml"
  s.add_dependency "migrant"
  s.add_dependency "virtus"

  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "psych"

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-livereload"
end
