module Effective
  class PagesController < ApplicationController
    def show
      @pages = Effective::Page.all

      if defined?(EffectiveRoles) && (current_user.respond_to?(:roles) rescue false)
        @pages = @pages.for_role(current_user.roles)
      end

      if [true, 'true'].include?(params[:edit]) == false
        @pages = @pages.published
      end

      @page = @pages.find(params[:id])

      EffectivePages.authorized?(self, :show, @page)

      @page_title = @page.title

      render @page.template, :layout => @page.layout, :locals => {:page => @page}
    end
  end
end
