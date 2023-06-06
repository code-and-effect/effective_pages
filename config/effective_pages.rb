EffectivePages.setup do |config|
  config.pages_table_name = :pages
  config.page_sections_table_name = :page_sections
  config.page_banners_table_name = :page_banners
  config.carousel_items_table_name = :carousel_items
  config.alerts_table_name = :alerts
  config.permalinks_table_name = :permalinks
  config.tags_table_name = :tags
  config.taggings_table_name = :taggings

  # The menu names a page can belong to
  config.menus = [:main, :footer]

  # The directory where your page templates live
  # Any files in this directory will be automatically available when
  # creating/editting an Effective::Page from the Admin screens
  # Relative to app/views/
  config.pages_path = 'effective/pages/'

  # The directory where your layouts live
  # Relative to app/views/
  config.layouts_path = 'layouts/'

  # Excluded Pages
  # Any page templates from the above directory that should be excluded
  config.excluded_pages = []

  # Excluded Layouts
  # Any app/views/layouts/ layout files that should be excluded
  config.excluded_layouts = [:admin]

  # The site_title will be used to populate the og:site_name tag
  config.site_title = "#{Rails.application.class.name.split('::').first.titleize}"

  # The site_title_suffix will be appended to the effective_pages_header_tags title tag
  config.site_title_suffix = " | #{Rails.application.class.name.split('::').first.titleize}"

  # This site_og_image is the filename for an image placed in /assets/images and will be used to populate the og:image tag
  config.site_og_image = ''
  config.site_og_image_width = ''  # Just 1024, no units
  config.site_og_image_height = ''

  # When using the effective_pages_header_tags() helper in <head> to set the <meta name='description'>
  # The value will be populated from an Effective::Page's .meta_description field,
  # a present @meta_description controller instance variable or this fallback value.
  # This will be truncated to 150 characters.
  config.fallback_meta_description = ''

  # Turn off missing meta page title and meta description warnings
  config.silence_missing_page_title_warnings = false
  config.silence_missing_meta_description_warnings = false
  config.silence_missing_canonical_url_warnings = false

  # Google Tag / Google Analytics 4 code
  # config.google_analytics_code = ''

  # Display the effective roles 'choose roles' input when an admin creates a new post
  config.use_effective_roles = false

  # Layout Settings
  # config.layout = { admin: 'admin' }

  # Menus
  # Strict bootstrap only supports depth 2. A root level and one dropdown.
  # Other sites can be configured such that the depth 3 menus are displayed on a sidebar.
  # Only 2 or 3 are supported right now
  config.max_menu_depth = 2

  # Page Banners
  # Allow a page banner to be selected on the Admin::Pages#edit screen
  # Banners can be CRUD by the admin
  config.banners = false
  config.banners_force_randomize = false # at least return a random banner with render_page_banner()
  config.banners_hint_text = 'Hint text that includes required image dimensions'

  # Page Carousels
  # The menu names a page can belong to
  config.carousels = false
  # config.carousels = [:home, :secondary]
  config.carousels_hint_text = 'Hint text that includes required image dimensions'

end
