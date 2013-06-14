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

    controller do
      def update
        if params[:commit] == 'Save and Edit Content'
          update! { |format| format.html { redirect_to '/edit/' + @effective_page.slug } }
        else
          update! { |format| format.html { redirect_to admin_effective_pages_path } }
        end
      end
    end

    form :partial => "active_admin/form"
  end
end
