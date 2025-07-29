module Admin
  class EffectiveBannerAdsDatatable < Effective::Datatable
    filters do
      scope :all
      scope :published
      scope :draft
    end

    datatable do
      order :updated_at

      col :updated_at, visible: false
      col :created_at, visible: false
      col :id, visible: false

      col :published?, as: :boolean
      col :published_start_at, label: "Published start", visible: false
      col :published_end_at, label: "Published end", visible: false

      col :location, search: EffectivePages.banner_ads
      col :name

      col :file, label: 'Image'
      col :caption, visible: false

      col(:path) do |banner_ad|
        if banner_ad.redirect_path.present?
          url = (root_url.chomp('/') + banner_ad.redirect_path)
          link_to(url, url, target: '_blank')
        end
      end

      col :url, visible: false
      col :slug, visible: false

      col :tracks_count, label: 'Clicks'

      actions_col
    end

    collection do
      Effective::BannerAd.deep.all
    end
  end
end
