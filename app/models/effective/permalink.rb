module Effective
  class Permalink < ApplicationRecord
    if defined?(PgSearch)
      include PgSearch::Model

      multisearchable against: [:title, :summary]
    end

    self.table_name = (EffectivePages.permalinks_table_name || :permalinks).to_s

    has_one_attached :attachment
    has_one_purgable :attachment

    acts_as_tagged
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
      title.presence || model_name.human
    end

    def redirect_path
      "/link/#{slug}"
    end

    def target
      url.present? ? :url : :attachment
    end

    private

    def attachment_and_url_cannot_both_be_present
      if url.present? && (attachment.attached? && !attachment.marked_for_destruction?)
        self.errors.add(:base, 'Attachment and URL cannot both be present')
      end
    end
  end
end
