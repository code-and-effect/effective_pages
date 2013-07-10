# EffectivePages Rails Engine

EffectivePages.setup do |config|
  config.pages_table_name = :pages
  config.templates_path = 'templates/'  # This is relative to your app/views/ directory

  # Use CanCan: can?(action, resource)
  # Use effective_roles:  resource.roles_match_with?(current_user)
  config.authorization_method = Proc.new { |controller, action, resource| true }

  #config.before_filter = :some_before_filter
  #config.before_filter = [:some_before_filter1, :some_before_filter2]
end
