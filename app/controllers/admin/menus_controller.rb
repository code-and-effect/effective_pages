module Admin
  class MenusController < ApplicationController
    before_action(:authenticate_user!)

    helper EffectiveMenusAdminHelper

    layout (EffectivePages.layout.kind_of?(Hash) ? EffectivePages.layout[:admin] : EffectivePages.layout)

    def index
      @datatable = EffectiveMenusDatatable.new(self)
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
        redirect_to effective_pages.admin_menu_path(@menu)
      else
        flash.now[:danger] = 'Unable to create menu'
        render :action => :new
      end
    end

    def show
      @menu = Effective::Menu.find(params[:id])
      @page_title = @menu.to_s

      authorize_effective_menus!
    end

    private

    def authorize_effective_menus!
      EffectiveResources.authorize!(self, :admin, :effective_pages)
      EffectiveResources.authorize!(self, action_name.to_sym, @menu || Effective::Menu)
    end

    def menu_params
      params.require(:effective_menu).permit!
    end

  end
end
