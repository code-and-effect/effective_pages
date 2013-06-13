require "effective_pages/engine"
require 'migrant'     # Required for rspec to run properly

module EffectivePages
  mattr_accessor :pages_table_name
  mattr_accessor :templates_path
  mattr_accessor :authorization_method

  def self.setup
    yield self
  end

  def self.authorized?(controller, resource, action)
    raise ActiveResource::UnauthorizedAccess.new('') unless (controller || self).instance_exec(controller, resource, action, &EffectivePages.authorization_method)
    true
  end

  def self.templates
    Rails.env.development? ? read_templates : (@@templates ||= read_templates)
  end

  def self.templates_info
    Rails.env.development? ? read_templates_info : (@@templates_info ||= read_templates_info)
  end

  private

  def self.read_templates
    regex = /page_region\s?\(?:([a-z_0-9]+)/
    templates = HashWithIndifferentAccess.new()

    begin
      files = ApplicationController.view_paths.map { |path| Dir["#{path}/templates/**"] }.flatten.reverse

      files.each do |file|
        template = File.basename(file).gsub(/.html.+/, '').to_sym
        regions = File.read(file).scan(regex).flatten.map(&:to_sym)

        templates[template] = HashWithIndifferentAccess.new(:regions => HashWithIndifferentAccess.new())
        regions.each { |region| templates[template][:regions][region] = HashWithIndifferentAccess.new() }
      end

      templates
    rescue => e
      HashWithIndifferentAccess.new()
    end
  end

  def self.read_templates_info
    begin
      HashWithIndifferentAccess.new(YAML.load(File.read('config/effective_pages.yml')))
    rescue => e
      HashWithIndifferentAccess.new()
    end
  end

end
