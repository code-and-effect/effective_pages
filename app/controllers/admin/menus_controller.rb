module Admin
  class MenusController < ApplicationController
    respond_to?(:before_action) ? before_action(:authenticate_user!) : before_filter(:authenticate_user!) # Devise

    helper EffectiveMenusAdminHelper

    layout (EffectivePages.layout.kind_of?(Hash) ? EffectivePages.layout[:admin] : EffectivePages.layout)

    def index
      @datatable = Effective::Datatables::Menus.new() if defined?(EffectiveDatatables)
      @page_title = 'Menus'

      authorize_effective_menus!
    end

    def new
      @menu = Effective::Menu.new()
      @page_title = 'New Menu'

      authorize_effective_menus!
    end

    def create
      @menu = Effective::Menu.new(menu_params)
      @page_title = 'New Menu'

      authorize_effective_menus!

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

      authorize_effective_menus!
    end

    def update
      @menu = Effective::Menu.find(params[:id])
      @page_title = 'Edit Menu'

      authorize_effective_menus!

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

      authorize_effective_menus!

      if @menu.destroy
        flash[:success] = 'Successfully deleted menu'
      else
        flash[:danger] = 'Unable to delete menu'
      end

      redirect_to effective_pages.admin_menus_path
    end

    private

    def authorize_effective_menus!
      EffectivePages.authorized?(self, :admin, :effective_pages)
      EffectivePages.authorized?(self, action_name.to_sym, @menu || Effective::Menu)
    end

    def menu_params
      params.require(:effective_menu).permit(:title)
    end

  end
end
