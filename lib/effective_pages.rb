require "effective_pages/engine"
require 'migrant'     # Required for rspec to run properly

module EffectivePages
  mattr_accessor :pages_table_name
  mattr_accessor :templates_path
  mattr_accessor :authorization_method

  def self.setup
    yield self
  end

  # Parse the effective_pages.yml YAML file
  # Cache the file in production.  Reload it in development.
  def self.templates
    begin
      if Rails.env.development?
        HashWithIndifferentAccess.new(YAML.load(File.read('config/effective_pages.yml')))
      else
        @@templates ||= HashWithIndifferentAccess.new(YAML.load(File.read('config/effective_pages.yml')))
      end
    rescue => e
    end || HashWithIndifferentAccess.new()
  end

  def self.authorized?(controller, resource, action)
    raise ActiveResource::UnauthorizedAccess.new('') unless (controller || self).instance_exec(controller, resource, action, &EffectivePages.authorization_method)
    true
  end

end
