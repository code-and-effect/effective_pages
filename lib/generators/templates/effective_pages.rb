# EffectivePages Rails Engine

EffectivePages.setup do |config|
  config.pages_table_name = :pages
  config.templates_path = 'templates/'  # This is relative to your app/views/ directory
  config.authorization_method = Proc.new { |controller, resource, action| can?(action, resource) }
end
