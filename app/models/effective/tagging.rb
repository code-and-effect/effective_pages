module Effective
  class Tagging < ApplicationRecord
    self.table_name = (EffectivePages.taggings_table_name || :taggings).to_s

    belongs_to :tag, class_name: 'Effective::Tag'
    belongs_to :taggable, polymorphic: true

    validates :tag,      presence: true
    validates :taggable, presence: true

    scope :deep, -> { all }

    effective_resource do
      tag_id          :integer
      taggable_id     :integer
      taggable_type   :string

      timestamps
    end

    validates :name, presence: true

    public

    def name
      tag.name
    end

    def to_s
      name
    end

    def tag_name
      tag.name
    end

    def tagged_on
      taggable_type.split('::').last
    end
  end
end
