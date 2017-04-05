module Admin
  class PagesController < ApplicationController
    respond_to?(:before_action) ? before_action(:authenticate_user!) : before_filter(:authenticate_user!) # Devise

    layout (EffectivePages.layout.kind_of?(Hash) ? EffectivePages.layout[:admin] : EffectivePages.layout)

    def index
      if Gem::Version.new(EffectiveDatatables::VERSION) < Gem::Version.new('3.0')
        @datatable = Effective::Datatables::Pages.new()
      else
        @datatable = EffectivePagesDatatable.new(self)
      end

      @page_title = 'Pages'

      authorize_effective_pages!
    end

    def new
      @page = Effective::Page.new()
      @page_title = 'New Page'

      authorize_effective_pages!
    end

    def create
      @page = Effective::Page.new(page_params)
      @page_title = 'New Page'

      authorize_effective_pages!

      if @page.save
        if params[:commit] == 'Save and Edit Content' && defined?(EffectiveRegions)
          redirect_to effective_regions.edit_path(effective_pages.page_path(@page), :exit => effective_pages.edit_admin_page_path(@page))
        elsif params[:commit] == 'Save and Add New'
          redirect_to effective_pages.new_admin_page_path
        else
          flash[:success] = 'Successfully created page'
          redirect_to effective_pages.edit_admin_page_path(@page)
        end
      else
        flash.now[:danger] = 'Unable to create page'
        render :action => :new
      end
    end

    def edit
      @page = Effective::Page.find(params[:id])
      @page_title = 'Edit Page'

      authorize_effective_pages!
    end

    def update
      @page = Effective::Page.find(params[:id])
      @page_title = 'Edit Page'

      authorize_effective_pages!

      if @page.update_attributes(page_params)
        if params[:commit] == 'Save and Edit Content' && defined?(EffectiveRegions)
          redirect_to effective_regions.edit_path(effective_pages.page_path(@page), :exit => effective_pages.edit_admin_page_path(@page))
        elsif params[:commit] == 'Save and Add New'
          redirect_to effective_pages.new_admin_page_path
        else
          flash[:success] = 'Successfully updated page'
          redirect_to effective_pages.edit_admin_page_path(@page)
        end
      else
        flash.now[:danger] = 'Unable to update page'
        render :action => :edit
      end
    end

    def destroy
      @page = Effective::Page.find(params[:id])

      authorize_effective_pages!

      if @page.destroy
        flash[:success] = 'Successfully deleted page'
      else
        flash[:danger] = 'Unable to delete page'
      end

      redirect_to effective_pages.admin_pages_path
    end

    private

    def authorize_effective_pages!
      EffectivePages.authorized?(self, :admin, :effective_pages)
      EffectivePages.authorized?(self, action_name.to_sym, @page|| Effective::Page)
    end

    def page_params
      params.require(:effective_page).permit(EffectivePages.permitted_params)
    end

  end
end
