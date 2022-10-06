module Effective
  class Page < ActiveRecord::Base
    attr_accessor :current_user
    attr_accessor :menu_root_level

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

      # Menu stuff
      menu              :boolean
      menu_name         :string

      menu_title        :string
      menu_url          :string
      menu_position     :integer

      # Access
      roles_mask        :integer
      authenticate_user :boolean

      timestamps
    end

    before_validation(if: -> { menu? && menu_position.blank? }) do
      self.menu_position = (self.class.where(menu_parent: menu_parent).maximum(:menu_position) || -1) + 1
    end

    validate(if: -> { menu_url.present? }) do
      unless menu_url.start_with?('http://') || menu_url.start_with?('https://') || menu_url.start_with?('/')
        self.errors.add(:menu_url, "must start with http(s):// or /")
      end
    end

    validates :title, presence: true, length: { maximum: 255 }
    validates :meta_description, presence: true, length: { maximum: 150 }

    validates :layout, presence: true
    validates :template, presence: true

    validates :menu_name, if: -> { menu_root? && EffectivePages.menus.present? }, presence: true

    # validates :menu_position, if: -> { menu? },
    #   presence: true, uniqueness: { scope: [:menu_name, :menu_parent_id] }

    scope :deep, -> { includes(:menu_parent, menu_children: :menu_parent) }

    scope :draft, -> { where(draft: true) }
    scope :published, -> { where(draft: false) }
    scope :sorted, -> { order(:title) }
    scope :on_menu, -> { where(menu: true) }
    scope :except_home, -> { where.not(title: 'Home') }

    scope :menuable, -> { published.where(menu: true).order(:menu_position) }
    scope :menu_deep, -> { includes(:menu_parent, :menu_children) }

    scope :for_menu, -> (name) { menuable.where(menu_name: name) }
    scope :for_menu_root, -> (name) { for_menu(name).menu_deep.root_level }
    scope :root_level, -> { where(menu_parent_id: nil) }

    def to_s
      title
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end

    def sidebar
      rich_text_sidebar
    end

    def published?
      !draft?
    end

    # Returns a duplicated post object, or throws an exception
    def duplicate
      Page.new(attributes.except('id', 'updated_at', 'created_at')).tap do |page|
        page.title = page.title + ' (Copy)'
        page.slug = page.slug + '-copy'

        rich_texts.each do |rt|
          page.send("rich_text_#{rt.name}=", rt.body)
        end

        page.draft = true
      end
    end

    def duplicate!
      duplicate.tap { |page| page.save! }
    end

    # When true, this should not appear in sitemap.xml and should return 404 if visited
    def menu_root_with_children?
      menu_root? && menu_parent?
    end

    # This is for the form
    def menu_root_level
      menu_root?
    end

    def menu_root?
      menu? && menu_parent_id.blank?
    end

    def menu_parent?
      menu? && menu_children.to_a.present?
    end

    def menu_child?
      menu? && menu_parent_id.present?
    end

  end

end
