module Effective
  class Tagging < ApplicationRecord
    self.table_name = (EffectivePages.taggings_table_name || :taggings).to_s

    belongs_to :tag, class_name: 'Effective::Tag'
    belongs_to :taggable, polymorphic: true

    scope :deep, -> { all }

    effective_resource do
      tag_id          :integer
      taggable_id     :integer
      taggable_type   :string

      timestamps
    end

    validates :tag_id, uniqueness: { scope: [:taggable_type, :taggable_id] }

    public

    def to_s
      name
    end
  end
end
