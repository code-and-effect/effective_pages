module Effective
  class PagesController < ApplicationController
    def show
      @pages = (Rails::VERSION::MAJOR > 3 ? Effective::Page.all : Effective::Page.scoped)
      @pages = @pages.published unless (params[:edit] || params[:preview])

      @page = @pages.find(params[:id])

      raise ActiveRecord::RecordNotFound unless @page.present? # Incase .find() isn't raising it
      raise Effective::AccessDenied unless @page.roles_permit?(current_user)

      EffectivePages.authorized?(self, :show, @page)

      @page_title = @page.title
      @meta_description = @page.meta_description

      render @page.template, :layout => @page.layout, :locals => {:page => @page}
    end
  end
end
