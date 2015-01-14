module Effective
  class MenuItem < ActiveRecord::Base
    attr_accessor :parent  # This gets set on the Root node and a node created by Dropdown, so the item function knows whether to go down or to go accross

    belongs_to :menu, :inverse_of => :menu_items
    belongs_to :menuable, :polymorphic => true # Optionaly belong to an object

    self.table_name = EffectivePages.menu_items_table_name.to_s
    attr_protected() if Rails::VERSION::MAJOR == 3

    structure do
      title           :string, :validates => [:presence]

      url             :string
      special         :string   # divider / search / *_path

      classes         :string
      new_window      :boolean, :default => false, :validates => [:inclusion => {:in => [true, false]}]
      roles_mask      :integer, :default => nil # 0 is going to mean logged in, nil is going to mean public, > 0 will be future implementation of roles masking

      lft             :integer, :validates => [:presence], :index => true
      rgt             :integer, :validates => [:presence]
    end

    default_scope -> { includes(:menuable).order(:lft) }

    def leaf?
      (rgt.to_i - lft.to_i) == 1
    end

    def dropdown?
      !leaf?
    end

    def divider?
      leaf? && special == 'divider'
    end

    # For now it's just logged in or not?
    # This will work with effective_roles one day...
    def visible_for?(user)
      can_view_page = (
        if menuable.kind_of?(Effective::Page) && defined?(EffectiveRoles) && menuable.is_role_restricted?
          (user.roles_match_with?(menuable) rescue false)
        else
          true
        end
      )

      can_view_menu_item = (
        if roles_mask == nil
          true
        elsif roles_mask == -1 # Am I logged out?
          user.blank?
        elsif roles_mask == 0 # Am I logged in?
          user.present?
        elsif roles_mask > 0 && defined?(EffectiveRoles)
          user.present? && (user.roles_permit?(roles_mask) rescue false)
        else
          false
        end
      )

      can_view_page && can_view_menu_item
    end

  end
end
