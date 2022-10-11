# Banners can be
module Effective
  class PageBanner < ActiveRecord::Base
    attr_accessor :current_user

    # Not used
    has_many_rich_texts

    # Can be displayed on multiple pages
    has_many :pages

    # For the image attachment
    has_one_attached :file

    log_changes if respond_to?(:log_changes)

    self.table_name = EffectivePages.page_banners_table_name.to_s

    effective_resource do
      name              :string       # Unique name of this page banner. Just used for reference.

      caption           :string

      timestamps
    end

    scope :deep, -> { with_attached_file.includes(:rich_texts) }
    scope :sorted, -> { order(:name) }
    scope :random, -> { order('RANDOM()') }

    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :file, presence: true

    validate(if: -> { file.attached? }) do
      self.errors.add(:file, 'must be an image') unless file.image?
    end

    def to_s
      name.presence || 'page banner'
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end

  end

end
