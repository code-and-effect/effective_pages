module Effective
  class Page < ActiveRecord::Base
    acts_as_sluggable
    acts_as_role_restricted if defined?(EffectiveRoles)
    acts_as_regionable if defined?(EffectiveRegions)

    self.table_name = EffectivePages.pages_table_name.to_s

    structure do
      title             :string, :validates => [:presence]
      meta_description  :string, :validates => [:presence]

      draft             :boolean, :default => false

      layout            :string, :default => 'application', :validates => [:presence]
      template          :string, :validates => [:presence]

      slug              :string
      roles_mask        :integer, :default => 0

      timestamps
    end

    scope :drafts, -> { where(:draft => true) }
    scope :published, -> { where(:draft => false) }
  end

end




