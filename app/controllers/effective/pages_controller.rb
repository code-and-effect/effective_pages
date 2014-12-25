module Effective
  class PagesController < ApplicationController
    def show
      @pages = (Rails::VERSION::MAJOR > 3 ? Effective::Page.all : Effective::Page.scoped)

      if defined?(EffectiveRoles) && (current_user.respond_to?(:roles) rescue false)
        @pages = @pages.for_role(current_user.roles)
      end

      if params[:edit].to_s != 'true'
        @pages = @pages.published
      end

      @page = @pages.find(params[:id])
      raise ActiveRecord::RecordNotFound unless @page

      EffectivePages.authorized?(self, :show, @page)

      @page_title = @page.title

      render @page.template, :layout => @page.layout, :locals => {:page => @page}
    end
  end
end
