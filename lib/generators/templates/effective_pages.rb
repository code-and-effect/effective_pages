# EffectivePages Rails Engine

EffectivePages.setup do |config|
  config.pages_table_name = :pages
  config.menus_table_name = :menus
  config.menu_items_table_name = :menu_items

  # Relative to app/views/
  config.pages_path = '/effective/pages/'

  # Excluded Pages
  config.excluded_pages = []

  # Excluded Layouts
  config.excluded_layouts = [:admin]

  # Use CanCan: can?(action, resource)
  # Use effective_roles:  resource.roles_match_with?(current_user)
  config.authorization_method = Proc.new { |controller, action, resource| true }

  # Layout Settings
  # Configure the Layout per controller, or all at once

  # config.layout = 'application'   # The layout for the EffectivePages admin screen
  config.layout = {
    :admin => 'application'
  }

  # SimpleForm Options
  # This Hash of options will be passed into any simple_form_for() calls
  config.simple_form_options = {}

  # config.simple_form_options = {
  #   :html => {:class => 'form-horizontal'},
  #   :wrapper => :horizontal_form,
  #   :wrapper_mappings => {
  #     :boolean => :horizontal_boolean,
  #     :check_boxes => :horizontal_radio_and_checkboxes,
  #     :radio_buttons => :horizontal_radio_and_checkboxes
  #   }
  # }

  # All effective_page menu options
  config.menu = {
    :apply_active_class => true,
    :maxdepth => 2
  }

end
