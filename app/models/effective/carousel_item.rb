# Carousels are configured in the config/initializers/effective_pages.rb
# Kind of like a menu, they are predefined and cannot be edited by admin
# The carousel items belong to a carousel through the string field
module Effective
  class CarouselItem < ActiveRecord::Base
    self.table_name = (EffectivePages.carousel_items_table_name || :carousel_items).to_s

    attr_accessor :current_user

    # For the body
    has_many_rich_texts

    # For the image attachment
    has_one_attached :file

    log_changes if respond_to?(:log_changes)

    effective_resource do
      carousel          :string  # The hardcoded carousel I render underneath

      title             :string
      caption           :string

      link_label        :string
      link_url          :string

      position          :integer

      timestamps
    end

    scope :deep, -> { with_attached_file.includes(:rich_texts) }
    scope :sorted, -> { order(:position, :id) }

    before_validation(if: -> { carousel.present? }) do
      self.position ||= 0
    end

    # Insert at top of the list
    before_save(if: -> { new_record? }) do
      self.class.where(carousel: carousel).where.not(id: id).update_all("position = position + 1")
    end

    validates :carousel, presence: true

    validates :title, presence: true, length: { maximum: 255 }
    validates :file, presence: true
    validates :position, presence: true

    validates :link_url, presence: true, if: -> { link_label.present? }
    validates :link_url, absence: true, if: -> { link_label.blank? }

    validate(if: -> { carousel.present? && EffectivePages.carousels? }) do
      unless (carousels = EffectivePages.carousels).find { |c| c.to_s == carousel.to_s }.present?
        errors.add(:carousel, "must be one of #{carousels.to_sentence}")
      end
    end

    validate(if: -> { file.attached? }) do
      errors.add(:file, 'must be an image') unless file.image?
    end

    def to_s
      persisted? ? [carousel, number].join(' ') : model_name.human
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end

    def number
      '#' + position.to_s
    end

  end

end
