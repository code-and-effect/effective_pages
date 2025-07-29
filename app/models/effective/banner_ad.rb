# Banner ads have an image attachment, title, location, and optional external URL
# Ads are assigned to a named location.
# If more than one published ad is assigned to a location, randomly select an ad when rendering the page. If there is only one ad for the location and date/time, always show the one ad.
module Effective
  class BannerAd < ActiveRecord::Base
    self.table_name = (EffectivePages.banner_ads_table_name || :banner_ads).to_s

    acts_as_published
    acts_as_slugged

    acts_as_trackable if respond_to?(:acts_as_trackable)
    log_changes if respond_to?(:log_changes)

    has_one_attached :file

    effective_resource do
      name              :string
      location          :string

      published_start_at       :datetime
      published_end_at         :datetime

      caption      :string
      url          :string
      
      # acts_as_slugged
      slug         :string

      # acts_as_trackable
      tracks_count :integer

      timestamps
    end

    validates :name, presence: true
    validates :location, presence: true
    validates :file, presence: true
    validates :url, url: true

    scope :deep, -> { with_attached_file }
    scope :sorted, -> { order(:name) }

    def to_s
      name.presence || model_name.human
    end

    def redirect_path
      "/ad/#{slug}" if url.present?
    end

    def track!(action: 'click', user: nil, details: nil)
      tracks.create!(action: action, user: user, details: details)
    end
  end
end
