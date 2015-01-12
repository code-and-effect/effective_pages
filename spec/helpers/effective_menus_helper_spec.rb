require 'spec_helper'

describe EffectiveMenusHelper do
  describe 'render_menu' do

    it 'correctly renders a menu with items' do
      menu = Effective::Menu.new(:title => 'test').build do
        item 'AAA'
        item 'BBB'
      end

      render_menu(menu).should eq "
        <ul class='nav navbar-nav'>
          <li>
            <a href='#'>AAA</a>
          </li>
          <li>
            <a href='#'>BBB</a>
          </li>
        </ul>
      ".gsub("\n", '').gsub('  ', '')
    end

    it 'correctly renders a menu with dropdowns' do
      menu = Effective::Menu.new(:title => 'test').build do
        dropdown 'About' do
          item 'AAA'
          item 'BBB'
        end

        dropdown 'Become a Member' do
          item '111'
          item '222'
        end

        item 'XXX'
      end.tap { |menu| menu.save }

      render_menu('test').should eq "
        <ul class='nav navbar-nav'>
          <li class='dropdown'>
            <a href='#' data-toggle='dropdown'>
              About
              <span class='caret'></span>
            </a>
            <ul class='dropdown-menu'>
              <li>
                <a href='#'>AAA</a>
              </li>
              <li>
                <a href='#'>BBB</a>
              </li>
            </ul>
          </li>
          <li class='dropdown'>
            <a href='#' data-toggle='dropdown'>
              Become a Member
              <span class='caret'></span>
            </a>
            <ul class='dropdown-menu'>
              <li>
                <a href='#'>111</a>
              </li>
              <li>
                <a href='#'>222</a>
              </li>
            </ul>
          </li>
          <li>
            <a href='#'>XXX</a>
          </li>
        </ul>
      ".gsub("\n", '').gsub('  ', '')
    end

    it 'correctly builds a menu with dropdowns inside dropdowns' do
      menu = Effective::Menu.new(:title => 'test').build do
        dropdown 'Fruit' do
          dropdown 'Red' do
            item 'Cherry'
          end

          dropdown 'Yellow' do
            item 'Banana'
          end
        end

        dropdown 'Meat' do
          item 'Beef'
          item 'Pork'
        end
      end.tap { |menu| menu.save }

      render_menu('test').should eq "
        <ul class='nav navbar-nav'>
          <li class='dropdown'>
            <a href='#' data-toggle='dropdown'>
              Fruit
              <span class='caret'></span>
            </a>
            <ul class='dropdown-menu'>
              <li class='dropdown'>
                <a href='#' data-toggle='dropdown'>Red</a>
                <ul class='dropdown-menu'>
                  <li>
                    <a href='#'>Cherry</a>
                  </li>
                </ul>
              </li>
              <li class='dropdown'>
                <a href='#' data-toggle='dropdown'>Yellow</a>
                <ul class='dropdown-menu'>
                  <li>
                    <a href='#'>Banana</a>
                  </li>
                </ul>
              </li>
            </ul>
          </li>
          <li class='dropdown'>
            <a href='#' data-toggle='dropdown'>
              Meat
              <span class='caret'></span>
            </a>
            <ul class='dropdown-menu'>
              <li>
                <a href='#'>Beef</a>
              </li>
              <li>
                <a href='#'>Pork</a>
              </li>
            </ul>
          </li>
        </ul>
      ".gsub("\n", '').gsub('  ', '')
    end

    it 'correctly renders a menu with dropdowns in dropdowns and items' do
      menu = Effective::Menu.new(:title => 'test').build do
        dropdown 'Events' do
          item 'Conferences'

          dropdown 'Workshops' do
            dropdown 'AAA' do
              item '111'
            end
            item 'BBB'
          end
        end
      end.tap { |menu| menu.save }

      render_menu('test').should eq "
        <ul class='nav navbar-nav'>
          <li class='dropdown'>
            <a href='#' data-toggle='dropdown'>
              Events
              <span class='caret'></span>
            </a>
            <ul class='dropdown-menu'>
              <li>
                <a href='#'>Conferences</a>
              </li>
              <li class='dropdown'>
                <a href='#' data-toggle='dropdown'>Workshops</a>
                <ul class='dropdown-menu'>
                  <li class='dropdown'>
                    <a href='#' data-toggle='dropdown'>AAA</a>
                    <ul class='dropdown-menu'>
                      <li>
                        <a href='#'>111</a>
                      </li>
                    </ul>
                  </li>
                  <li>
                    <a href='#'>BBB</a>
                  </li>
                </ul>
              </li>
            </ul>
          </li>
        </ul>
      ".gsub("\n", '').gsub('  ', '')

    end
  end
end
