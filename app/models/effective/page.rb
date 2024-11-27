module Effective
  class Page < ActiveRecord::Base
    self.table_name = (EffectivePages.pages_table_name || :pages).to_s

    if defined?(PgSearch)
      include PgSearch::Model

      multisearchable against: [:body]
    end

    attr_accessor :current_user
    attr_accessor :menu_root_level

    belongs_to :page_banner, optional: true

    # These parent / children are for the menu as well
    belongs_to :menu_parent, class_name: 'Effective::Page', optional: true, touch: true, counter_cache: :menu_children_count

    has_many :menu_children, -> { Effective::Page.menuable }, class_name: 'Effective::Page',
      foreign_key: :menu_parent_id, inverse_of: :menu_parent

    has_many :page_segments, -> { Effective::PageSegment.sorted }, class_name: 'Effective::PageSegment', inverse_of: :page, dependent: :destroy
    accepts_nested_attributes_for :page_segments, allow_destroy: true

    acts_as_role_restricted if respond_to?(:acts_as_role_restricted)
    acts_as_paginable
    acts_as_published
    acts_as_slugged
    acts_as_tagged
    has_many_rich_texts
    log_changes if respond_to?(:log_changes)

    effective_resource do
      title             :string
      meta_description  :string

      published_start_at       :datetime
      published_end_at         :datetime
      legacy_draft             :boolean       # No longer used. To be removed.

      layout            :string
      template          :string

      slug              :string

      # Menus
      menu              :boolean        # Should this be displayed on the menu at all?
      menu_name         :string         # When I'm a root level item, this is the menu I render underneath
      menu_group        :string         # Used for design. Group by menu_group to display full dropdowns.

      menu_title        :string         # Displayed on the menu instead of title
      menu_url          :string         # Redirect to this url instead of the page url
      menu_position     :integer        # Position in the menu

      menu_children_count :integer      # Counter cache

      # Banners
      banner            :boolean        # Should we display a banner?
      banner_random     :boolean        # Display a random banner

      # Access
      roles_mask        :integer
      authenticate_user :boolean

      timestamps
    end

    scope :deep, -> { 
      base = includes(:page_banner, :tags, :rich_texts) 
      base = base.deep_menuable
      base = base.includes(:pg_search_document) if defined?(PgSearch)
      base
    }

    scope :deep_menuable, -> { includes(:menu_parent, menu_children: [:menu_parent, :menu_children]) }
    scope :sorted, -> { order(:title) }

    scope :on_menu, -> { where(menu: true) }
    scope :except_home, -> { where.not(title: 'Home') }

    scope :menuable, -> { published.where(menu: true).menu_sorted }
    scope :menu_deep, -> { includes(:menu_parent, :menu_children) }
    scope :menu_sorted, -> { order(:menu_position) }

    scope :for_menu, -> (name) { menuable.where(menu_name: name) }
    scope :for_menu_root, -> (name) { for_menu(name).menu_deep.root_level }
    scope :root_level, -> { where(menu_parent_id: nil) }

    scope :menu_root_with_children, -> { menu_parents.where(menu_parent_id: nil) }
    scope :menu_roots, -> { where(menu: true).where(menu_parent_id: nil) }
    scope :menu_parents, -> { where(menu: true).where(id: Effective::Page.select('menu_parent_id')).menu_sorted }
    scope :menu_children, -> { where(menu: true).where.not(menu_parent_id: nil).menu_sorted }

    scope :for_sitemap, -> {
      published.where(menu: false).or(published.where(menu: true).where.not(id: menu_root_with_children))
    }

    scope :pages, -> (user: nil, unpublished: false) {
      scope = all.deep.sorted

      if defined?(EffectiveRoles) && EffectivePages.use_effective_roles
        scope = scope.for_role(user&.roles)
      end

      unless unpublished
        scope = scope.published
      end

      scope
    }

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

    validates :menu_name, presence: true, if: -> { menu_root? && EffectivePages.menus.present? }

    # Doesn't make sense for a top level item to have a menu group
    validates :menu_group, absence: true, if: -> { menu_root? && EffectivePages.menus.present? }

    validate(if: -> { banner? && EffectivePages.banners? }) do
      unless (page_banner.present? ^ banner_random? ^ EffectivePages.banners_force_randomize) # xor
        self.errors.add(:page_banner_id, "please select a page banner or random")
        self.errors.add(:banner_random, "please select a page banner or random")
      end
    end

    def to_s
      title.presence || model_name.human
    end

    def menu_to_s
      (menu_title.presence || title)
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end

    def sidebar
      rich_text_sidebar
    end

    # Returns a duplicated post object, or throws an exception
    def duplicate
      Page.new(attributes.except('id', 'updated_at', 'created_at')).tap do |page|
        page.title = page.title + ' (Copy)'
        page.slug = page.slug + '-copy'

        rich_texts.each do |rt|
          page.send("rich_text_#{rt.name}=", rt.body)
        end

        page.assign_attributes(published_start_at: nil, published_end_at: nil)
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
      menu? && menu_children_present?
    end

    def menu_child?
      menu? && menu_parent_id.present?
    end

    def menu_children_present?
      menu_children_count > 0
    end

    def menu_children_blank?
      menu_children_count <= 0
    end

    # Checked by render_page_segments_menu() to see if this page should render the page_segments menu
    def template_page_segments?
      template == 'page_segments'
    end
  end
end
