module Effective
  class PagesController < ApplicationController
    respond_to :html
    skip_authorization_check

    def show
      @page = Effective::Page.find(params[:id])

      raise ActiveRecord::RecordNotFound unless @page.published?

      @page_title = @page.title
      @meta_description = @page.meta_description
      @meta_keywords = @page.meta_keywords
      render "pages/#{@page.template}"
    end

    def index
    end

  end
end
