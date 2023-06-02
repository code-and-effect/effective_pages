module Effective
  class Permalink < ApplicationRecord
    self.table_name = (EffectivePages.permalinks_table_name || :permalinks).to_s

    has_one_attached :attachment

    acts_as_slugged

    log_changes if respond_to?(:log_changes)

    scope :deep, -> { with_attached_attachment }

    effective_resource do
      title        :string
      slug         :string

      url          :string

      summary      :text

      timestamps
    end

    validate  :attachment_and_url_cannot_both_be_present

    validates :title,       presence: true
    validates :attachment,  presence: true, if: -> { url.blank?          }
    validates :url,         presence: true, if: -> { attachment.blank?   }, url: true

    public

    def to_s
      title
    end

    def redirect_url
      "/permalinks/#{slug}"
    end

    def target
      url.present? ? :url : :attachment
    end

    private

    def attachment_and_url_cannot_both_be_present
      if attachment.attached? && url.present?
        self.errors.add(:base, 'Attachment and URL cannot both be present')
      end
    end
  end
end
