module Effective
  class PermalinksController < ApplicationController
    def redirect
      @permalink = Effective::Permalink.find_by! slug: params[:slug]

      authorize! :redirect, @permalink

      redirect_to redirect_path_for(@permalink), allow_other_host: (@permalink.target == :url)
    end

    private

    def redirect_path_for(permalink)
      permalink.target == :attachment ? attachment_url(permalink.attachment) : permalink.url
    end

    def attachment_url(permalink)
      Rails.application.routes.url_helpers.rails_blob_path(permalink, only_path: true)
    end
  end
end
