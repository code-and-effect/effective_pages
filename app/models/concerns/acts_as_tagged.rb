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

    def tags=(ids)
      # IDs are coming as string and with a blank one, that was causing an error - "".to_i turns into 0 so we remove it
      ids = ids.map { |id| id.to_i }.reject { |id| id == 0 }.uniq

      # Delete any existing Tags that aren't in this array
      tags.each { |tag| tag.mark_for_destruction unless ids.include?(tag.id) }

      # Create any new Tags
      all_tags = Effective::Tag.where(id: ids).to_a # Just to prevent N+1 queries

      ids.each do |tag_id|
        next if taggings.any? { |tagging| tagging.tag_id == tag_id }

        tag = all_tags.find { |tag| tag.id == tag_id }
        raise "Tag not found #{tag_id}" if tag.blank?

        self.tags << tag
      end
    end
  end

  module ClassMethods
    def acts_as_tagged?; true; end
  end
end
