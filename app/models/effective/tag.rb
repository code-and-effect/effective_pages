module Effective
  class Tag < ApplicationRecord
    self.table_name = (EffectivePages.tags_table_name || :tags).to_s

    log_changes if respond_to?(:log_changes)

    has_many :taggings, class_name: 'Effective::Tagging', dependent: :delete_all

    scope :deep,   -> { all }
    scope :sorted, -> { order(:name) }

    effective_resource do
      name        :string

      timestamps
    end

    validates :name, presence: true
    validates :name, uniqueness: true

    public

    def to_s
      name.presence || model_name.human
    end
  end
end
