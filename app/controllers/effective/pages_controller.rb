# https://gist.github.com/hiroshi/985457

module Effective
  class PagesController < ApplicationController
    respond_to :html
    skip_authorization_check

    def show
      @page = Effective::Page.where(:slug => params[:id]).first
      #raise ActiveRecord::RecordNotFound unless @page.published?

      template = EffectivePages.templates[@page.template]
      raise EffectivePages::TemplateNotFound.new(@page.template) unless (template and template.kind_of?(Hash))

      # Set our header information
      @page_title = @page.title
      @meta_description = @page.meta_description
      @meta_keywords = @page.meta_keywords

      # Set our content areas
      (template[:sections] || {}).each do |section, opts|
        content_for section, @page.sections[section] || opts[:placeholder].to_s
      end

      render "#{EffectivePages::templates_path.chomp('/')}/#{@page.template}", :layout => (template[:layout] || :application)
    end

    private

    def view_context
      super.tap do |view|
        (@_content_for || {}).each { |name, content| view.content_for name, content }
      end
    end

    def content_for(section, content)
      (@_content_for ||= {})[section.to_sym] = content
    end
  end
end
