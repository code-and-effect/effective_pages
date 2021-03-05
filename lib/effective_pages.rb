require 'effective_datatables'
require 'effective_resources'
require 'effective_roles'
require 'effective_pages/engine'
require 'effective_pages/version'

module EffectivePages
  def self.config_keys
    [
      :pages_table_name, :menus_table_name, :menu_items_table_name,
      :pages_path, :excluded_pages, :layouts_path, :excluded_layouts,
      :site_og_image, :site_og_image_width, :site_og_image_height,
      :site_title, :site_title_suffix, :fallback_meta_description,
      :silence_missing_page_title_warnings, :silence_missing_meta_description_warnings, :silence_missing_canonical_url_warnings,
      :use_effective_roles, :menus, :menu, :layout
    ]
  end

  include EffectiveGem

  def self.templates
    ApplicationController.view_paths.map { |path| Dir[File.join(path, pages_path, '**')] }.flatten.map do |file|
      name = File.basename(file).split('.').first
      next if name.starts_with?('_')
      next if Array(EffectivePages.excluded_pages).map { |str| str.to_s }.include?(name)
      name
    end.compact.sort
  end

  def self.layouts
    return [] if layouts_path.blank?

    ApplicationController.view_paths.map { |path| Dir[File.join(path, layouts_path, '**')] }.flatten.map do |file|
      name = File.basename(file).split('.').first
      next if name.starts_with?('_')
      next if name.include?('mailer')
      next if Array(EffectivePages.excluded_layouts).map { |str| str.to_s }.include?(name)
      name
    end.compact.sort
  end

end
