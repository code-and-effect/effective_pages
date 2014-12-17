module Effective
  class PagesController < ApplicationController
    def show
      @page = Effective::Page.find(params[:id])

      EffectivePages.authorized?(self, :show, @page)

      @page_title = @page.title

      render @page.template, :layout => @page.layout, :locals => {:page => @page}
    end
  end
end
