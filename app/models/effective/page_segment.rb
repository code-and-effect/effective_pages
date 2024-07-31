# For use with the the ScrollSpy pages
# Each PageSegment will be considered with the page_segments / scrollspy menu

module Effective
  class PageSegment < ActiveRecord::Base
    self.table_name = (EffectivePages.page_segments_table_name || :page_segments).to_s

    belongs_to :page, touch: true

    has_many_rich_texts
    log_changes(to: :page) if respond_to?(:log_changes)

    effective_resource do
      title             :string
      position          :integer

      timestamps
    end

    before_validation(if: -> { page.present? }) do
      self.position ||= (page.page_segments.map(&:position).compact.max || -1) + 1
    end

    validates :title, presence: true, uniqueness: { scope: :page_id }
    validates :position, presence: true

    scope :deep, -> { includes(:page, :rich_texts) }
    scope :sorted, -> { order(:position) }

    def to_s
      title.presence || model_name.human
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end

    def uid
      title.parameterize
    end
  end
end
