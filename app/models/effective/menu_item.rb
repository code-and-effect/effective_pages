module Effective
  class MenuItem < ActiveRecord::Base
    attr_accessor :parent  # This gets set on the Root node and a node created by Dropdown, so the item function knows whether to go down or to go accross

    belongs_to :menu, inverse_of: :menu_items
    belongs_to :menuable, polymorphic: true # Optionaly belong to an object

    self.table_name = EffectivePages.menu_items_table_name.to_s

    acts_as_role_restricted

    effective_resource do
      title           :string

      url             :string
      special         :string  # divider / search / *_path

      classes         :string
      new_window      :boolean
      roles_mask      :integer # 0 is going to mean logged in, -1 is going to mean public, > 0 will be future implementation of roles masking

      lft             :integer
      rgt             :integer

      timestamps
    end

    validates :title, presence: true, length: { maximum: 255 }
    validates :url, length: { maximum: 255 }
    validates :special, length: { maximum: 255 }
    validates :classes, length: { maximum: 255 }
    validates :new_window, inclusion: { in: [true, false] }

    validates :lft, presence: true
    validates :rgt, presence: true

    scope :deep, -> { includes(:menuable) }
    scope :sorted, -> { order(:lft) }

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
        if dropdown?
          true
        elsif menuable.kind_of?(Effective::Page)
          menuable.roles_permit?(user)
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
        else
          roles_permit?(user)
        end
      )

      can_view_page && can_view_menu_item
    end

  end
end
