# frozen_string_literal: true
module EffectiveAlertsHelper

  def effective_alerts
    @_effective_alerts ||= Effective::Alert.all.enabled
  end

  def render_effective_alerts
    effective_alerts
      .map { |alert| render 'effective/alerts/alert', alert: alert }
      .join
      .html_safe
  end

end
