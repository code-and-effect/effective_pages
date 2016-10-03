module Admin
  class MenusController < ApplicationController
    respond_to?(:before_action) ? before_action(:authenticate_user!) : before_filter(:authenticate_user!) # Devise

    helper EffectiveMenusAdminHelper

    layout (EffectivePages.layout.kind_of?(Hash) ? EffectivePages.layout[:admin] : EffectivePages.layout)

    def index
      @datatable = Effective::Datatables::Menus.new() if defined?(EffectiveDatatables)
      @page_title = 'Menus'

      EffectivePages.authorized?(self, :index, Effective::Menu)
    end

    def new
      @menu = Effective::Menu.new()
      @page_title = 'New Menu'

      EffectivePages.authorized?(self, :new, @menu)
    end

    def create
      @menu = Effective::Menu.new(menu_params)
      @page_title = 'New Menu'

      EffectivePages.authorized?(self, :create, @menu)

      if @menu.save
        flash[:success] = 'Successfully created menu'
        redirect_to effective_pages.edit_admin_menu_path(@menu)
      else
        flash.now[:danger] = 'Unable to create menu'
        render :action => :new
      end
    end

    def edit
      @menu = Effective::Menu.find(params[:id])
      @page_title = 'Edit Menu'

      EffectivePages.authorized?(self, :edit, @menu)
    end

    def update
      @menu = Effective::Menu.find(params[:id])
      @page_title = 'Edit Menu'

      EffectivePages.authorized?(self, :update, @menu)

      if @menu.update_attributes(menu_params)
        flash[:success] = 'Successfully updated menu'
        redirect_to effective_pages.edit_admin_menu_path(@menu)
      else
        flash.now[:danger] = 'Unable to update menu'
        render :action => :edit
      end
    end

    def destroy
      @menu = Effective::Menu.find(params[:id])

      EffectivePages.authorized?(self, :destroy, @menu)

      if @menu.destroy
        flash[:success] = 'Successfully deleted menu'
      else
        flash[:danger] = 'Unable to delete menu'
      end

      redirect_to effective_pages.admin_menus_path
    end

    private

    def menu_params
      params.require(:effective_menu).permit(:title)
    end

  end
end
