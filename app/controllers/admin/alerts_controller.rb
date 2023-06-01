module Admin
  class AlertsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }

    include Effective::CrudController

    page_title 'Alerts'

    def permitted_params
      params.require(:effective_alert).permit!
    end

  end
end
