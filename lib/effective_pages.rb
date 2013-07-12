require "effective_pages/engine"
require 'migrant'     # Required for rspec to run properly

module EffectivePages
  mattr_accessor :pages_table_name
  mattr_accessor :templates_path
  mattr_accessor :authorization_method
  mattr_accessor :before_filter

  def self.setup
    yield self
  end

  def self.authorized?(controller, action, resource)
    raise ActiveResource::UnauthorizedAccess.new('') unless (controller || self).instance_exec(controller, action, resource, &EffectivePages.authorization_method)
    true
  end

  def self.templates
    Rails.env.development? ? read_templates : (@@templates ||= read_templates)
  end

  def self.templates_info
    Rails.env.development? ? read_templates_info : (@@templates_info ||= read_templates_info)
  end

  def self.snippets
    Rails.env.development? ? read_snippets : (@@snippets ||= read_snippets)
  end

  private

  def self.read_templates
    regex = /page_region\s?\(?:([a-z_0-9]+)/
    templates = HashWithIndifferentAccess.new()

    begin
      # Reversing here so the app's templates folder has precedence.
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

  def self.read_snippets
    snippets = []

    begin
      # Reversing here so the app's templates folder has precedence.
      files = ApplicationController.view_paths.map { |path| Dir["#{path}/effective/snippets/**"] }.flatten.reverse

      files.each do |file|
        snippet = File.basename(file)
        if (klass = "Effective::Snippets::#{snippet.try(:classify)}".safe_constantize)
          snippets << klass unless snippets.include?(klass)
        end
      end

      snippets
    rescue => e
      []
    end
  end
end
