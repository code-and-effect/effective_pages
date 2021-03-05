module Effective
  class Page < ActiveRecord::Base
    attr_accessor :current_user

    # These parent / children are for the menu as well
    belongs_to :menu_parent, class_name: 'Effective::Page', optional: true

    has_many :menu_children, -> { Effective::Page.menuable }, class_name: 'Effective::Page',
      foreign_key: :menu_parent_id, inverse_of: :menu_parent

    acts_as_role_restricted
    acts_as_slugged
    has_many_rich_texts

    log_changes if respond_to?(:log_changes)

    self.table_name = EffectivePages.pages_table_name.to_s

    effective_resource do
      title             :string
      meta_description  :string

      draft             :boolean

      layout            :string
      template          :string

      slug              :string

      roles_mask        :integer
      authenticate_user :boolean

      # Menu stuff
      menu              :boolean
      menu_name         :string
      menu_url          :string
      menu_position     :integer

      timestamps
    end

    validates :title, presence: true, length: { maximum: 255 }
    validates :meta_description, presence: true, length: { maximum: 150 }

    validates :template, presence: true

    # validates :menu_name, if: -> { menu? },
    #   presence: true, inclusion: { in: EffectivePages.menus }

    # validates :menu_position, if: -> { menu? },
    #   presence: true, uniqueness: { scope: [:menu_name, :menu_parent_id] }

    scope :drafts, -> { where(draft: true) }
    scope :published, -> { where(draft: false) }
    scope :sorted, -> { order(:title) }
    scope :except_home, -> { where.not(title: 'Home') }

    scope :menuable, -> { where(menu: true).order(:menu_position) }
    scope :for_menu, -> (name) { menuable.where(menu_name: name) }

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
