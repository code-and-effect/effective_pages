module Effective
  class MercuryController < ApplicationController
    protect_from_forgery
    skip_authorization_check
    #before_filter :authenticate, :only => :edit
    layout false

    def edit
      @requested_uri = params[:requested_uri]
      @page = Effective::Page.where(:slug => params[:requested_uri]).first

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

    def test_page
      render :text => params
    end

    private

    def authenticate
      redirect_to "/#{params[:requested_uri]}" unless can_edit?
    end
  end
end
