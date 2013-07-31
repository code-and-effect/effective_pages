# This was pretty much all taken and tweaked from
# https://github.com/josevalim/inherited_resources/blob/master/lib/inherited_resources/base_helpers.rb

module Effective::ResourceController::Helpers

  protected

  # This is how the collection is loaded.
  def collection
    get_collection_ivar || begin
      c = end_of_association_chain
      if defined?(ActiveRecord::DeprecatedFinders)
        # ActiveRecord::Base#scoped and ActiveRecord::Relation#all
        # are deprecated in Rails 4. If it's a relation just use
        # it, otherwise use .all to get a relation.
        set_collection_ivar(c.is_a?(ActiveRecord::Relation) ? c : c.all)
      else
        set_collection_ivar(c.respond_to?(:scoped) ? c.scoped : c.all)
      end
    end
  end

  # This is how the resource is loaded.
  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_find, params[:id]))
  end

  def build_resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build, *resource_params))
  end

  def create_resource(object)
    object.save
  end

  def update_resource(object, attributes)
    object.update_attributes(*attributes)
  end

  def destroy_resource(object)
    object.destroy
  end

  # Returns finder method for instantiate resource by params[:id]
  def method_for_find
    :find
  end

  private

  def resource_collection_name
    self.controller_name.to_sym
  end

  def resource_instance_name
    self.controller_name.singularize.to_sym
  end

  def resource_request_name
    self.resource_class.to_s.underscore.gsub('/', '_')
  end

  # Get resource ivar based on the current resource controller.
  #
  def get_resource_ivar #:nodoc:
    instance_variable_get("@#{resource_instance_name}")
  end

  # Set resource ivar based on the current resource controller.
  #
  def set_resource_ivar(resource) #:nodoc:
    instance_variable_set("@#{resource_instance_name}", resource)
  end

  # Get collection ivar based on the current resource controller.
  #
  def get_collection_ivar #:nodoc:
    instance_variable_get("@#{resource_collection_name}")
  end

  # Set collection ivar based on the current resource controller.
  #
  def set_collection_ivar(collection) #:nodoc:
    instance_variable_set("@#{resource_collection_name}", collection)
  end

  # memoize the extraction of attributes from params
  def resource_params
    @resource_params ||= build_resource_params
  end

  # extract attributes from params
  def build_resource_params
    parameters = respond_to?(:permitted_params, true) ? permitted_params : params
    [parameters[resource_request_name] || parameters[resource_instance_name] || {}]
  end

  def resource_class
    @resource_class ||= begin
      namespaced_class = self.class.name.sub(/Controller/, '').singularize
      namespaced_class.constantize
    rescue NameError
      nil
    end

    # Second priority is the top namespace model, e.g. EngineName::Article for EngineName::Admin::ArticlesController
    @resource_class ||= begin
      namespaced_classes = self.class.name.sub(/Controller/, '').split('::')
      namespaced_class = [namespaced_classes.first, namespaced_classes.last].join('::').singularize
      namespaced_class.constantize
    rescue NameError
      nil
    end

    # Third priority the camelcased c, i.e. UserGroup
    @resource_class ||= begin
      camelcased_class = self.class.name.sub(/Controller/, '').gsub('::', '').singularize
      camelcased_class.constantize
    rescue NameError
      nil
    end

    # Otherwise use the Group class, or fail
    @resource_class ||= begin
      class_name = self.controller_name.classify
      class_name.constantize
    rescue NameError => e
      raise unless e.message.include?(class_name)
      nil
    end
  end

  def with_chain(object)
    [end_of_association_chain] + [ object ]
  end

  # This methods gets your begin_of_association_chain, join it with your
  # parents chain and returns the scoped association.
  def end_of_association_chain #:nodoc:
    resource_class
  end

  # Used to allow to specify success and failure within just one block:
  #
  # def create
  # create! do |success, failure|
  # failure.html { redirect_to root_url }
  # end
  # end
  #
  # It also calculates the response url in case a block without arity is
  # given and returns it. Otherwise returns nil.
  #
  def respond_with_dual_blocks(object, options, &block) #:nodoc:
    args = (with_chain(object) << options)

    case block.try(:arity)
    when 2
      respond_with(*args) do |responder|
        blank_slate = Effective::ResourceController::BlankSlate.new
        if object.errors.empty?
          block.call(responder, blank_slate)
        else
          block.call(blank_slate, responder)
        end
      end
    when 1
      respond_with(*args, &block)
    else
      options[:location] = block.call if block
      respond_with(*args)
    end
  end

end
