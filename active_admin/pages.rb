if defined?(ActiveAdmin)
  ActiveAdmin.register Effective::Page do
    menu :label => "Pages", :if => proc { EffectivePages.authorized?(controller, Effective::Page, :manage) rescue false }

    filter :title
    filter :created_at

    scope :published, :default => true
    scope :drafts
    scope :all

    index :download_links => false do
      column :title
      column :template
      column :published
      default_actions
    end

    sidebar :help, :only => :index do
      span "The page with the slug 'home' will be used as the homepage.".html_safe
    end

    form :partial => "active_admin/form"
  end
end
