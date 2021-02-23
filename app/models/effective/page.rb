module Effective
  class Page < ActiveRecord::Base
    attr_accessor :current_user

    acts_as_slugged

    log_changes if respond_to?(:log_changes)
    acts_as_role_restricted

    has_rich_text :body
    has_many :menu_items, as: :menuable, dependent: :destroy

    self.table_name = EffectivePages.pages_table_name.to_s

    effective_resource do
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

    validates :template, presence: true

    scope :drafts, -> { where(draft: true) }
    scope :published, -> { where(draft: false) }
    scope :sorted, -> { order(:title) }
    scope :except_home, -> { where.not(title: 'Home') }

    def to_s
      title
    end

    def published?
      !draft?
    end

    # Returns a duplicated post object, or throws an exception
    def duplicate
      Page.new(attributes.except('id', 'updated_at', 'created_at')).tap do |page|
        page.title = page.title + ' (Copy)'
        page.slug = page.slug + '-copy'
        page.draft = true

        post.body = body
      end
    end

    def duplicate!
      duplicate.tap { |page| page.save! }
    end

  end

end
