module Effective
  class Alert < ApplicationRecord
    self.table_name = (EffectivePages.alerts_table_name || :alerts).to_s

    log_changes if respond_to?(:log_changes)

    has_rich_text :body

    effective_resource do
      enabled         :boolean

      timestamps
    end

    scope :deep,    -> { with_rich_text_body  }
    scope :enabled, -> { where(enabled: true) }

    validates :body, presence: true

    def to_s
      'alert'
    end

  end
end
