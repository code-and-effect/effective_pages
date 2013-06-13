module Effective
  class MercuryController < ApplicationController
    skip_authorization_check if defined?(CanCan)
    layout false

    def edit
      @requested_uri = params[:requested_uri]
      @page ||= Effective::Page.where(:slug => params[:requested_uri]).first
      EffectivePages.authorized?(self, @page, :update)

      if params[:mercury_frame]
        redirect_to '/' + params[:requested_uri] + '?mercury_frame=true'
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
