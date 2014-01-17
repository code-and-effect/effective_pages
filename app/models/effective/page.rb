module Effective
  class Page < ActiveRecord::Base
    acts_as_sluggable
    acts_as_role_restricted if defined?(EffectiveRoles)

    self.table_name = EffectivePages.pages_table_name.to_s

    structure do
      title             :string, :validates => [:presence]
      meta_keywords     :string, :validates => [:presence]
      meta_description  :string, :validates => [:presence]
      draft             :boolean, :default => false

      template          :string, :validates => [:presence]
      regions           :text
      snippets          :text

      roles_mask        :integer
      slug              :string

      timestamps
    end

    serialize :regions, Hash
    serialize :snippets, Hash

    scope :drafts, -> { where(:draft => true) }
    scope :published, -> { where(:draft => false) }

    def regions
      self[:regions] || HashWithIndifferentAccess.new()
    end

    def snippets
      self[:snippets] || HashWithIndifferentAccess.new()
    end

    def form(obj = nil, additional_snippet_objects = nil)
      @page_form ||= Effective::PageForm.new((snippet_objects + [additional_snippet_objects]).flatten.compact).tap do |form|
        attributes = {}

        if obj.kind_of?(Hash)
          attributes = obj['effective_page_form'] || obj
        elsif obj.respond_to?(:attributes)
          attributes = obj.attributes
        end

        attributes.each { |k, v| form.send("#{k}=", v) rescue nil }
      end
    end

    def snippet_objects
      snippets.map do |k, snippet|
        klass = "Effective::Snippets::#{snippet['name'].try(:classify)}".safe_constantize
        klass ? (klass.new(snippet['options'] || snippet) rescue nil) : nil
      end
    end
  end
end




