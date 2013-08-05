require 'virtus'

module Effective
  class PageForm
    include Virtus

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    def initialize(snippet_objects = [])
      # I don't like this code...I can't seem to add attributes/validations on the singleton class
      # These shouldn't be on the PageForm class.
      self.class.reset_callbacks(:validate)

      snippet_objects.each do |obj|
        next unless obj.name.present?

        case obj.value_type
        when Hash
          obj.value_type.each { |vname, vtype| create_attribute("#{obj.name}_#{vname}", obj.required?, vtype) }
        else
          create_attribute(obj.name, obj.required?, obj.value_type)
        end
      end
    end

    def create_attribute(name, required = false, value_type = String)
      self.class.instance_eval { attribute name, value_type }
      self.class.instance_eval { validates_presence_of name } if required
    end

    def persisted?
      false
    end

    def update_attributes(atts)
      return true unless atts
      atts.each { |k, v| self.send("#{k}=", v) }
      save
    end

    def save
      return false if self.respond_to?(:before_validation) and before_validation == false

      begin
        valid?
      rescue => e
        Rails.logger.info e.to_s
        false
      end
    end
  end
end
