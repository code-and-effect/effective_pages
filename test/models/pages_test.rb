require 'test_helper'

class PagesTest < ActiveSupport::TestCase
  test 'is valid' do
    page = build_effective_page()
    assert page.valid?

    assert_equal 'page', page.template
    assert_equal 'application', page.layout
  end
end
