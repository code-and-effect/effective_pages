require 'test_helper'

class PagesTest < ActiveSupport::TestCase
  test 'is valid' do
    page = build_effective_page()
    assert page.valid?

    assert_equal 'page', page.template
  end

  test 'published? and draft?' do
    page = build_effective_page()
    page.save!
    assert page.published?
    refute page.draft?

    page.update!(published_start_at: nil)
    refute page.published?
    assert page.draft?
    refute Effective::Page.published.include?(page)
    assert Effective::Page.draft.include?(page)

    page.update!(published_start_at: Time.zone.now)
    assert page.published?
    refute page.draft?
    assert Effective::Page.published.include?(page)
    refute Effective::Page.draft.include?(page)

    page.update!(published_start_at: 2.minutes.ago, published_end_at: 1.minute.ago)
    refute page.published?
    assert page.draft?
    refute Effective::Page.published.include?(page)
    assert Effective::Page.draft.include?(page)
  end

  test 'sitemap includes public pages and excludes restricted pages on and off the menu' do
    [false, true].each do |menu|
      [nil, 0].each do |roles_mask|
        [nil, false].each do |authenticate_user|
          page = build_effective_page()
          page.assign_attributes(menu: menu, menu_name: EffectivePages.menus.first, roles_mask: roles_mask, authenticate_user: authenticate_user)
          page.save!

          assert Effective::Page.for_sitemap.exists?(page.id), 'Public pages should appear in the sitemap'
        end
      end

      [{ roles_mask: 1 }, { authenticate_user: true }].each do |restriction|
        page = build_effective_page()
        page.assign_attributes({ menu: menu, menu_name: EffectivePages.menus.first }.merge(restriction))
        page.save!

        refute Effective::Page.for_sitemap.exists?(page.id), 'Restricted pages should not appear in the sitemap'
      end
    end
  end

end
