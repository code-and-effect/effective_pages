module Effective
  class Page < ActiveRecord::Base
    if defined?(PgSearch)
      include PgSearch::Model

      pg_search_scope :search,
                      against: [
                        :title,
                        :menu_title,
                        :meta_description,
                        :slug,
                      ],
                      using: { tsearch: { highlight: true }, trigram: { word_similarity: true } }

      multisearchable against: [
                        :title,
                        :menu_title,
                        :meta_description,
                        :slug,
                      ],
                      using: {
                        trigram: {},
                        tsearch: {
                          highlight: true,
                        }
                      },
                      ranked_by: ":trigram", # Could rank by any column/expression, e.g.: (books.num_pages * :trigram) + (:tsearch / 2.0)
                      if: -> (page) { page.published? }
    end

    attr_accessor :current_user
    attr_accessor :menu_root_level

    belongs_to :page_banner, optional: true

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

      # Menus
      menu              :boolean        # Should this be displayed on the menu at all?
      menu_name         :string         # When I'm a root level item, this is the menu I render underneath
      menu_group        :string         # Used for design. Group by menu_group to display full dropdowns.

      menu_title        :string         # Displayed on the menu instead of title
      menu_url          :string         # Redirect to this url instead of the page url
      menu_position     :integer        # Position in the menu

      # Banners
      banner            :boolean        # Should we display a banner?
      banner_random     :boolean        # Display a random banner

      # Access
      roles_mask        :integer
      authenticate_user :boolean

      timestamps
    end

    scope :deep, -> { includes(:page_banner, :menu_parent, menu_children: :menu_parent) }

    scope :draft, -> { where(draft: true) }
    scope :published, -> { where(draft: false) }
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

    # Maybe change paginate to be an isolated function instead of a scope, so we can use it with PgSearch::Document when doing a whole app search?
    scope :paginate, -> (page: nil, per_page: nil) {
      page = (page || 1).to_i
      offset = [(page - 1), 0].max * per_page

      limit(per_page).offset(offset)
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
      title
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
