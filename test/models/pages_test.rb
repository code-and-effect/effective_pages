require 'test_helper'

class PagesTest < ActiveSupport::TestCase
  test 'is valid' do
    page = build_effective_page()
    assert page.valid?

    assert_equal 'page', page.template
    assert_equal 'application', page.layout
  end

  test 'published? and draft?' do
    page = build_effective_page()
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

    page.update!(published_end_at: Time.zone.now)
    refute page.published?
    assert page.draft?
    refute Effective::Page.published.include?(page)
    assert Effective::Page.draft.include?(page)
  end

end
