module Effective
  class PagesController < ApplicationController
    def show
      @pages = Effective::Page.all
      @pages = @pages.published unless (params[:edit] || params[:preview])

      @page = @pages.find(params[:id])

      EffectiveResources.authorize!(self, :show, @page)

      @page_title = @page.title
      @meta_description = @page.meta_description

      render @page.template, :layout => @page.layout, :locals => {:page => @page}
    end
  end
end
