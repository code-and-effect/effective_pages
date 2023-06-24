module ActsAsTagged
  extend ActiveSupport::Concern

  module Base
    def acts_as_tagged(*options)
      @acts_as_tagged = options || []
      include ::ActsAsTagged
    end
  end

  included do
    has_many :taggings, as: :taggable, class_name: 'Effective::Tagging', dependent: :delete_all

    has_many :tags, through: :taggings, class_name: 'Effective::Tag'

    accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true

    #
    # Create or assign tags based on the input
    #
    # @param [Array<String, Integer>] input An array of tag names and/or tag ids, with possible blank strings
    #
    # @return [void]
    #
    def tag_ids=(input) # named after the field name in `effective_pages/app/views/effective/tags/_fields.html.haml`
      input = (input - ['']).group_by { |value| value.gsub(/\D/, '').to_i > 0 }

      ids = (input[true] || []).map(&:to_i)
      names = input[false] || []

      # Delete any existing Tags that aren't in this array
      tags.each { |tag| tag.mark_for_destruction unless ids.include?(tag.id) }

      # Create any new Tags
      ids.each do |tag_id|
        taggings.find { |tagging| tagging.tag_id == tag_id } || self.tags << Effective::Tag.find(tag_id)
      end

      names.each { |name| self.tags.build(name: name) }
    end
  end

  module ClassMethods
    def acts_as_tagged?; true; end
  end
end
