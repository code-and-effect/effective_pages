module Effective
  class Page < ActiveRecord::Base
    acts_as_sluggable
    acts_as_role_restricted if defined?(EffectiveRoles)

    self.table_name = EffectivePages.pages_table_name.to_s

    structure do
      title             :string, :validates => [:presence]
      meta_keywords     :string, :validates => [:presence]
      meta_description  :string, :validates => [:presence]
      draft             :boolean, :default => false, :validates => [:boolean]

      template          :string, :validates => [:presence]
      regions           :text
      snippets          :text

      slug              :string

      timestamps
    end

    serialize :regions, Hash
    serialize :snippets, Hash

    scope :drafts, -> { where(:draft => true) }
    scope :published, -> { where(:draft => false) }

    def regions
      self[:regions] || {}
    end

    def snippets
      self[:snippets] || {}
    end
  end
end
