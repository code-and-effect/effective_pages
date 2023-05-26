require 'effective_resources'
require 'effective_datatables'
require 'effective_regions'
require 'effective_roles'
require 'effective_slugs'
require 'effective_pages/engine'
require 'effective_pages/version'

module EffectivePages

  def self.config_keys
    [
      :pages_table_name, :menus_table_name, :menu_items_table_name,
      :pages_path, :excluded_pages, :excluded_layouts,
      :site_og_image, :site_title, :site_title_suffix, :fallback_meta_description,
      :silence_missing_page_title_warnings, :silence_missing_meta_description_warnings,
      :simple_form_options, :layout, :menu, :acts_as_asset_box
    ]
  end

  include EffectiveGem

  def self.templates
    ApplicationController.view_paths.map { |path| Dir["#{path}/#{pages_path}/**"] }.flatten.reverse.map do |file|
      name = File.basename(file).split('.').first
      next if name.starts_with?('_')
      next if Array(EffectivePages.excluded_pages).map { |str| str.to_s }.include?(name)
      name
    end.compact
  end

  def self.layouts
    ApplicationController.view_paths.map { |path| Dir["#{path}/layouts/**"] }.flatten.reverse.map do |file|
      name = File.basename(file).split('.').first
      next if name.starts_with?('_')
      next if name.include?('mailer')
      next if Array(EffectivePages.excluded_layouts).map { |str| str.to_s }.include?(name)
      name
    end.compact
  end

  # Remove leading and trailing '/' characters
  #  Will return:  "effective/pages"
  def self.pages_path=(filepath)
    filepath = filepath.to_s
    filepath = filepath[1..-1] if filepath.starts_with?('/')
    @@pages_path = filepath.chomp('/')
  end

end
