require 'factory_girl'

FactoryGirl.define do
  factory :page, :class => Effective::Page do
    sequence(:title) { |n| "Title #{n}" }

    meta_keywords 'meta keywords'
    meta_description 'meta description'
    draft false

    template 'template1'

    before(:create) { |page| page.regions = HashWithIndifferentAccess.new({:title => 'Page Title', :content => '<p>Page Content</p><p>[snippet_0/1]</p>'}) }
    before(:create) { |page| page.snippets = HashWithIndifferentAccess.new({:snippet_0 => HashWithIndifferentAccess.new(:name => 'text_field_tag', :options => HashWithIndifferentAccess.new(:name => 'sadness', :required => 'on', :label => 'A sad input', :html_classes => 'span4'))}) }
  end
end
