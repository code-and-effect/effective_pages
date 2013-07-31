module Effective::ResourceController::Base
  extend ActiveSupport::Concern

  include Effective::ResourceController::Actions
  include Effective::ResourceController::Helpers

  included do
    skip_authorization_check if defined?(CanCan)
    respond_to :html
  end

end
