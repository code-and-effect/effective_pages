module Effective
  class PageSection < ActiveRecord::Base
    attr_accessor :current_user

    # Not used
    belongs_to :owner, polymorphic: true, optional: true

    has_many_rich_texts
    has_many_attached :files

    log_changes if respond_to?(:log_changes)

    self.table_name = EffectivePages.page_sections_table_name.to_s

    effective_resource do
      name              :string       # Unique name of this page section

      title             :string
      caption           :string

      link_label        :string
      link_url          :string

      hint              :text

      timestamps
    end

    validates :name, presence: true, uniqueness: true
    validates :title, presence: true, length: { maximum: 255 }

    validates :link_url, presence: true, if: -> { link_label.present? }
    validates :link_url, absence: true, if: -> { link_label.blank? }

    scope :deep, -> { with_attached_files.includes(:rich_texts) }
    scope :sorted, -> { order(:name) }

    def to_s
      name.presence || 'page section'
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end

  end

end
