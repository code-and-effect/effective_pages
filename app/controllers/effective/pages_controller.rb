module Effective
  class PagesController < ApplicationController
    def show
      @pages = (Rails::VERSION::MAJOR > 3 ? Effective::Page.all : Effective::Page.scoped)
      @pages = @pages.published if params[:edit].to_s != 'true'

      @page = @pages.find(params[:id])

      raise ActiveRecord::RecordNotFound unless @page.present? # Incase .find() isn't raising it
      raise Effective::AccessDenied unless @page.roles_permit?(current_user)

      EffectivePages.authorized?(self, :show, @page)

      @page_title = @page.title

      render @page.template, :layout => @page.layout, :locals => {:page => @page}
    end
  end
end
