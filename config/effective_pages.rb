EffectivePages.setup do |config|
  config.pages_table_name = :pages
  config.page_sections_table_name = :page_sections

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

  # Display the effective roles 'choose roles' input when an admin creates a new post
  config.use_effective_roles = false

  # Layout Settings
  # config.layout = { admin: 'admin' }

  # Menus
  # Strict bootstrap only supports depth 2. A root level and one dropdown.
  # Other sites can be configured such that the depth 3 menus are displayed on a sidebar.
  # Only 2 or 3 are supported right now
  config.max_menu_depth = 2

end
