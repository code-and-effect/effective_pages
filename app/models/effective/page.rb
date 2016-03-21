module Effective
  class Page < ActiveRecord::Base
    acts_as_sluggable
    acts_as_role_restricted
    acts_as_regionable

    if EffectivePages.acts_as_asset_box.present?
      acts_as_asset_box [EffectivePages.acts_as_asset_box]
    end

    has_many :menu_items, as: :menuable, dependent: :destroy

    self.table_name = EffectivePages.pages_table_name.to_s

    structure do
      title             :string
      meta_description  :string

      draft             :boolean

      layout            :string
      template          :string

      slug              :string
      roles_mask        :integer

      timestamps
    end

    validates :title, presence: true, length: { maximum: 255 }
    validates :meta_description, presence: true, length: { maximum: 150 }
    validates :layout, presence: true
    validates :template, presence: true

    scope :drafts, -> { where(draft: true) }
    scope :published, -> { where(draft: false) }
  end

end




