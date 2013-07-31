module ActsAsEffectiveResourceController
  extend ActiveSupport::Concern

  module ActionController
    def acts_as_effective_resource_controller(*options)
      @acts_as_effective_resource_controller_opts = options || []
      include Effective::ResourceController::Base
    end
  end
end
