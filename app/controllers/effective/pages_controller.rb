module Effective
  class PagesController < ApplicationController
    respond_to :html
    skip_authorization_check

    def show
      @page = Effective::Page.where(:slug => params[:id]).first
      #raise ActiveRecord::RecordNotFound unless @page.published?

      template = EffectivePages.templates[@page.template]
      raise EffectivePages::TemplateNotFound.new(@page.template) unless (template and template.kind_of?(HashWithIndifferentAccess))

      # Assign all content areas
      (template[:sections] || {}).each do |section, opts|
        content_for section, @page.sections[section] || opts[:placeholder].to_s
      end

      render "#{EffectivePages::templates_path.chomp('/')}/#{@page.template}", :layout => (template[:layout] || :application)
    end

    def update
      @page = Effective::Page.where(:slug => params[:id]).first

      render :text => '', :status => 200
    end

    private

    # https://gist.github.com/hiroshi/985457
    def content_for(section, content)
      (@_content_for ||= {})[section] = content
    end

    def view_context
      super.tap do |view|
        (@_content_for || {}).each { |name, content| view.content_for name, content }
      end
    end
  end
end
