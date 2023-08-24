module EffectivePagesTestBuilder

  def build_effective_page
    layout = EffectivePages.layouts.first
    template = EffectivePages.templates.first
    
    Effective::Page.new(
      title: 'Home',
      meta_description: 'Home',
      layout: layout,
      template: template,
      rich_text_body: '<p>great body</p>',
      rich_text_sidebar: '<p>great sidebar</p>'
    )
  end
end
