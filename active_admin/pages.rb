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
      column :draft
      column :slug

      column do |page|
        link_to('Visit', EffectivePages::Engine.routes.url_helpers.effective_page_path(page), :class => 'member_link') +
        link_to('Edit', edit_admin_effective_page_path(page), :class => 'member_link') +
        link_to('Edit Content', EffectivePages::Engine.routes.url_helpers.edit_effective_page_path(page), :class => 'member_link') +
        link_to('Delete', admin_effective_page_path(page), :confirm => 'Are you sure? This cannot be undone!', :method => :delete, :class => 'member_link')
      end
    end

    sidebar :home_page, :only => :index, :if => proc { application_root_to_effective_pages_slug.present? } do
      span "The page with slug '#{application_root_to_effective_pages_slug}' will be used as the homepage.".html_safe
    end

    controller do
      def create
        if params[:commit] == 'Save and Edit Content'
          create! { effective_pages.edit_effective_page_path(@effective_page) }
        else
          create! { admin_effective_pages_path }
        end
      end

      def update
        if params[:commit] == 'Save and Edit Content'
          update! { effective_pages.edit_effective_page_path(@effective_page) }
        else
          update! { admin_effective_pages_path }
        end
      end
    end

    form :partial => "active_admin/form"
  end
end
