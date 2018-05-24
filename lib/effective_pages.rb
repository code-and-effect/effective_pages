require 'effective_datatables'
require 'effective_regions'
require 'effective_roles'
require 'effective_pages/engine'
require 'effective_pages/version'

module EffectivePages
  mattr_accessor :pages_table_name
  mattr_accessor :menus_table_name
  mattr_accessor :menu_items_table_name

  mattr_accessor :pages_path
  mattr_accessor :excluded_pages
  mattr_accessor :excluded_layouts

  mattr_accessor :site_og_image
  mattr_accessor :site_title
  mattr_accessor :site_title_suffix
  mattr_accessor :fallback_meta_description

  mattr_accessor :silence_missing_page_title_warnings
  mattr_accessor :silence_missing_meta_description_warnings

  mattr_accessor :authorization_method
  mattr_accessor :layout
  mattr_accessor :menu

  def self.setup
    yield self
  end

  def self.authorized?(controller, action, resource)
    @_exceptions ||= [Effective::AccessDenied, (CanCan::AccessDenied if defined?(CanCan)), (Pundit::NotAuthorizedError if defined?(Pundit))].compact

    return !!authorization_method unless authorization_method.respond_to?(:call)
    controller = controller.controller if controller.respond_to?(:controller)

    begin
      !!(controller || self).instance_exec((controller || self), action, resource, &authorization_method)
    rescue *@_exceptions
      false
    end
  end

  def self.authorize!(controller, action, resource)
    raise Effective::AccessDenied.new('Access Denied', action, resource) unless authorized?(controller, action, resource)
  end

  def self.pages
    Rails.env.development? ? read_pages : (@@pages ||= read_pages)
  end

  def self.layouts
    Rails.env.development? ? read_layouts : (@@layouts ||= read_layouts)
  end

  # Remove leading and trailing '/' characters
  #  Will return:  "effective/pages"
  def self.pages_path=(filepath)
    filepath = filepath.to_s
    filepath = filepath[1..-1] if filepath.starts_with?('/')
    @@pages_path = filepath.chomp('/')
  end

  def self.permitted_params
    @@permitted_params ||= [:title, :meta_description, :draft, :layout, :template, :slug, (EffectiveAssets.permitted_params if EffectivePages.acts_as_asset_box), roles: []].compact
  end

  private

  def self.read_pages
    files = ApplicationController.view_paths.map { |path| Dir["#{path}/#{pages_path}/**"] }.flatten.reverse

    HashWithIndifferentAccess.new().tap do |pages|
      files.each do |file|
        name = File.basename(file).split('.').first
        next if name.starts_with?('_') || Array(EffectivePages.excluded_pages).map { |str| str.to_s }.include?(name)

        pages[name.to_sym] = {}
      end
    end
  end

  def self.read_layouts
    files = ApplicationController.view_paths.map { |path| Dir["#{path}/layouts/**"] }.flatten.reverse

    HashWithIndifferentAccess.new().tap do |layouts|
      files.each do |file|
        name = File.basename(file).split('.').first
        next if name.starts_with?('_')
        next if name.include?('mailer')
        next if Array(EffectivePages.excluded_layouts).map { |str| str.to_s }.include?(name)

        layouts[name.to_sym] = {}
      end
    end
  end

end
