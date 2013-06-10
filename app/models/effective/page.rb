module Effective
  class Page < ActiveRecord::Base
    self.table_name = EffectivePages.pages_table_name.to_s

    structure do
      title             :string, :validates => [:presence]
      meta_keywords     :string, :validates => [:presence]
      meta_description  :string, :validates => [:presence]

      template          :string, :validates => [:presence]
      sections          :text

      published         :boolean, :default => true, :validates => [:boolean]
      slug              :string

      timestamps
    end

    serialize :sections, Hash

    scope :drafts, -> { where(:published => false) }
    scope :published, -> { where(:published => true) }
  end
end
