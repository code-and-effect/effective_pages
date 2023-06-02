module Effective
  class PermalinksController < ApplicationController
    skip_authorization_check # Public access for permalinks

    before_action :set_permalink

    delegate :target, :attachment, :url, to: :@permalink

    def redirect
      redirect_to target_url, allow_other_host: other_host?
    end

    private

    def set_permalink
      @permalink = Effective::Permalink.find_by! slug: params[:slug]
    end

    def target_url
      target == :attachment ? attachment_url(attachment) : url
    end

    def other_host?
      target == :url
    end

    def attachment_url(permalink)
      Rails.application.routes.url_helpers.rails_blob_path(permalink, only_path: true)
    end
  end
end
