# Page sections are only created by seeds / a developer
# They are referenced by name
# The admin user can only edit/update content
module Effective
  class PageSection < ActiveRecord::Base
    self.table_name = (EffectivePages.page_sections_table_name || :page_sections).to_s

    attr_accessor :current_user

    has_many_rich_texts
    has_one_attached :file

    log_changes if respond_to?(:log_changes)

    effective_resource do
      name              :string       # Set by developer. The unique name of this page section
      hint              :text         # Set by developer. A hint to display to user.

      title             :string
      caption           :string

      link_label        :string
      link_url          :string

      timestamps
    end

    validates :name, presence: true, uniqueness: true
    validates :title, presence: true, length: { maximum: 255 }

    validates :link_url, presence: true, if: -> { link_label.present? }
    validates :link_url, absence: true, if: -> { link_label.blank? }

    scope :deep, -> { with_attached_file.includes(:rich_texts) }
    scope :sorted, -> { order(:name) }

    def to_s
      name.presence || model_name.human
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end

  end

end
