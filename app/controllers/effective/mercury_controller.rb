module Effective
  class MercuryController < ApplicationController
    skip_authorization_check if defined?(CanCan)
    layout false

    def edit
      @page = Effective::Page.find(params[:id])
      EffectivePages.authorized?(self, @page, :update)

      if params[:mercury_frame]
        redirect_to effective_pages.effective_page_path(@page, :mercury_frame => true)
      else
        render :text => '', :layout => 'mercury'
      end
    end

    def resource
      render :action => "/#{params[:type]}/#{params[:resource]}"
    end

    def snippet_options
      @options = params[:options] || {}
      render :action => "/snippets/#{params[:name]}/options"
    end

    def snippet_preview
      render :action => "/snippets/#{params[:name]}/preview"
    end
  end
end
