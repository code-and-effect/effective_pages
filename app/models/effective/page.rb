module Effective
  class Page < ActiveRecord::Base
    acts_as_sluggable

    self.table_name = EffectivePages.pages_table_name.to_s

    structure do
      title             :string, :validates => [:presence]
      meta_keywords     :string, :validates => [:presence]
      meta_description  :string, :validates => [:presence]

      template          :string, :validates => [:presence]
      regions           :text

      published         :boolean, :default => true, :validates => [:boolean]
      slug              :string

      timestamps
    end

    serialize :regions, Hash

    scope :drafts, -> { where(:published => false) }
    scope :published, -> { where(:published => true) }

    def regions
      self[:regions] || {}
    end
  end
end
