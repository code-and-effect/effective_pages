require 'factory_girl'

FactoryGirl.define do
  factory :page, :class => Effective::Page do
    sequence(:title) { |n| "Title #{n}" }

    meta_description 'meta description'
    draft false

    template 'template1'
  end
end
