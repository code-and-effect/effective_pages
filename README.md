# Effective Pages

Content pages, bootstrap3 menu builder and page-specific header tag helpers for your Rails app.

Create content pages ontop of one or more templates -- just regular Rails views -- that you define and control.

Edit menus with a WYSIWYG drag-and-drop bootstrap3-strict menu builder.

Use this gem to create a fully-functional CMS that provides full or restricted editing for your end users.

Built ontop of effective_regions.

Rails 3.2.x and 4.x


## Getting Started

Please first install the [effective_regions](https://github.com/code-and-effect/effective_regions) and [effective_datatables](https://github.com/code-and-effect/effective_datatables) gems.

Please download and install [Twitter Bootstrap3](http://getbootstrap.com)

Add to your Gemfile:

```ruby
gem 'effective_pages'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_pages:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table name (to use something other than the default 'pages', 'menus', 'menu_items'), manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

Add the following helper to your application layout in the `<head>..</head>` section.  This will properly create `<title>` and `<meta description>` tags based on the Effective::Page and the controller instance variables `@page_title` and `@meta_description` for non Effective::Page routes.

```ruby
= effective_pages_header_tags
```

There are no required javascript or stylesheet includes.


### Post Installation

Once the above Getting Started tasks have been completed, there are still a few small things that need to be initialized and configured.

The documentation for these post-installation tasks is split up into the following Pages and Menus sections.


## Pages

To create your first content page, visit `/admin/pages` and click `New Page`.

This first page will be created with the provided `example` page view template and allow you to immediately jump into the effective_regions editor when you click `Save and Edit Content`.

This page will be available on your website at a route matching the slugified title.

### View Template and Layout

Every Effective::Page is rendered by a regular Rails view file and layout.  The same as any standard Rails #show action.

When creating a Page, if the `app/views/layouts/` directory contains more than one layout file, you will be able to choose which layout to use when displaying this Page.  If your Rails app contains only the default `application` layout then this layout will be used.

As well, when creating your Effective::Page object, if the `app/views/effective/pages/` directory contains more than one view file, you will be able to choose which view is used to display this Page.

When this gem's installation generator is run, the `app/views/effective/pages/example.html.haml` page view template is created.  To add additional page view templates, just create more views in this directory.

An example of a two-column layout I like to create is as follows:

```haml
%h1
  = simple_effective_region page, :header do
    = page.title

.row
  .col-sm-6
    = effective_region page, :left do
      %p this is default left column content
  .col-sm-6
    = effective_region page, :right do
      %p this is default right column content
```

You can add anything to these page views. The views are not required to contain any effective_regions, but then they wouldn't be user-editable.

### Routes

All Effective::Page pages are immediately available to your application at a url matching the slugified title.

This gem's page routes are evaluated last, after all your existing routes.  This may cause an issue if you create an Effective::Page titled `Events` but you already have a route matching `/events` such as `resources :events`.  You can edit the Effective::Page object and set the slug to a value that does not conflict.

To find the path for an Effective::Page object:

```ruby
page = Effective::Page.find_by_title('My Page')

effective_pages.page_path(page)
effective_pages.page_url(page)
```

If you would like to use an Effective::Page for your home/root page, add the following to your routes.rb:

Rails 3 Syntax:

```ruby
root :to => 'Effective::Pages#show', :id => 'home'
```

Rails 4 Syntax:

```ruby
root :to => 'effective/pages#show', :id => 'home'
```

and make sure a page with slug 'home' exists.


### Header Tags

Your layout needs to be configured to set the appropriate html `<title>` and `<meta>` tags.

In your application layout and any additional layouts files, add the following to the `<head>` section:

```ruby
= effective_pages_header_tags
```

This helper inserts a `<title>...</title>` html tag based on the `@page_title` instance variable, which you can set anywhere on your non-effective controllers, and whose value is set to the `@page.title` value when displaying an `Effective::Page`.

This helper also inserts a `<meta name='description' content='...' />` html tag based on the `@meta_description` instance variable, which you can set anywhere on your non-effective controllers, and whose value is set to the `@page.meta_description` value when displaying an `Effective::Page`.  This tag provides the content that search engines use to display their search results.  This value will automatically be truncated to 150 characters.

This helper will also warn about missing `@page_title` and `@meta_description` variables.  You can turn off the warnings in the config file.

This helper is entirely optional and in no way required for effective_pages to work.

### Body Tag Classes

Another optional helper.  Add the following to your `<body>` tag:

```haml
%body{:class => effective_pages_body_classes}
```

to apply the following html classes:  `params[:controller]`, `params[:action]`, `signed-in` / `not-signed-in`, `@page.template` and any thing set in the `@body_classes` instance variable.

This provides a mechanism to easily target CSS styles for specific pages.

This helper is entirely optional and in no way required for effective_pages to work.

### Permissions

When creating a Page, if you've also installed the [effective_roles](https://github.com/code-and-effect/effective_roles) gem, you will be able to configure user access on a per-page basis.

Use this functionality to create member-only type pages.


## Menus

The menus rendered by this gem output strict bootstrap3 (v3.3.2) html.  It is intended for bootstrap3 navbars as well as footer menus, sidebar menus and more.  It outputs the ul tag and all contained li items:

```html
<ul class="nav navbar-nav">
...
</ul>
```

The bootstrap3 `.active` class will be added to the appropriate li item based on the current page.


### Create a menu

Each Effective::Menu object is referred to by its title. The title is unique, so only one `'main menu'` can exist.

To display our first menu, we must create an Effective::Menu object and then render it in the Rails application layout or appropriate view.

To create your first menu, either:

- Visit `/admin/menus` and click `New Menu`.  Give it a title: `'main menu'`.

or

- Run `bundle exec rake effective_pages:seed` to create a menu called `'main menu'` with some placeholder menu items.

then add it to your application layout where you would normally display your site's menu:

```html
= render_menu('main menu')
```

or with some additional custom classes rendered on the opening `<ul>` tag

```html
= render_menu('main menu', :class => 'menu-right')
```


### Editing menu items

Once created and displayed by your application layout, the menu items will be drag-and-drop editable on any page where the menu is present.  This menu editting functionality requires the [effective_regions](https://github.com/code-and-effect/effective_regions) gem.

So to edit the menu, visit any page on your website prefixed with `/edit/`.  This will load the effective_regions editor, and all displayed Effective::Menu menus will have a dotted blue border which indicates it to be an editable region.

NOTE: Right now, the page you visit to edit the menu must contain an effective_region somewhere in a view.  This requirement may be removed in the future.  The menu editor will not work unless at least one effective_region is used somewhere on the page.

Once you're on the edit page and see the dotted blue bordered menus:

- Hover over the menu to click the Add button.
- Drag-and-drop items around to set their position in the menu.
- Drag-and-drop a menu item onto the trashcan icon to delete it.
- Double-click a menu item to bring up a dialog and configure its properties.

The menu item dialog provides all configurable options for each menu item.

A menu item's link can be configured in four different ways:

- Page, links to an Effective::Page object
- URL, any url you type
- Route, any rails route, such as destroy_user_session_path, root_path, or events_path
- Divider, an li with class='divider'

From this dialog, you can also configure permissions and add raw html classes.

Clicking 'Save' from the toolbar will persist the changes you've made to any menus.


### Menu building DSL

Menus may also be created programatically.

As an Aside:

- To store the Effective::Menu tree structure, this gem implements the Modified Preorder Tree Traversal algorithm.
- Check out the [Storing Hierarchial Data in a Database](http://www.sitepoint.com/hierarchical-data-database-2/) guide for background information on this algorithm.
- You don't have to worry about any lft and rgt values when building menus with this gem.

To create the same tree structure used in the above article:

```ruby
Effective::Menu.new(:title => 'some menu').build do
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
end.save
```

and another more advanced example:

```ruby
Effective::Menu.new(:title => 'main menu').build do
  dropdown 'About' do
    item Effective::Page.find_by_title('Who Are We?')
    divider
    item Effective::Page.find_by_title('Code of Ethics'), '#', :class => 'nav-indent'
    item Effective::Page.find_by_title('Entrance Requirements'), '#', :class => 'nav-indent'
    item Effective::Page.find_by_title('Board and Staff')
  end

  item 'Portal', :user_portal_path
  item 'Pay Fees', '/fee_payments/new'
  item 'Events', :events_path

  dropdown 'Current Members', :roles_mask => 1 do # effective_roles. Only members see this dropdown
    item Effective::Page.find_by_title('Volunteer Opportunities')
    item Effective::Page.find_by_title('Mentoring')
  end

  dropdown 'Account', :signed_in => true do # Only current_user.present? users see this dropdown
    item 'Site Admin', '/admin', :roles_mask => 3 # effective_roles.  Only admins see this item
    item 'Account Settings', :user_settings_path
    divider
    item 'Downloads', '#'
    item 'Mentoring Resources', '#'
    divider
    item 'Sign Out', :destroy_user_session_path
  end

  item 'Sign In', :new_user_session_path, :signed_out => true # Only current_user.blank? users see this item
end.save
```

The entire DSL consists of just 3 commands:  dropdown, item and divider

with the following valid options:

```ruby
:signed_in => true|false    # Only signed in (current_user.present?) users see this item
:signed_out => true|false   # Only signed out (current_user.blank?) users see this item
:roles_mask => 1            # See effective_roles Bitmask Implementation
:class => 'custom classes'  # Custom HTML classes
:new_window => true         # Open link in a new window
```

### Max Depth

The default max-depth for bootstrap3 menus is 2.  As per the bootstrap3 navbar component, there exist only top level items and top level dropdowns that may contain only li items.  No dropdowns in dropdowns.

This gem has the ability to extend the bootstrap3 functionality and provides support for dropdowns inside dropdowns to any nested depth.

To enable this functionality, require the following stylesheet on the asset pipeline by adding to your application.css:

```ruby
*= require effective_pages
```

and change the `config.menu[:maxdepth]` value in the `app/config/initializers/effective_pages.rb` initializer to 3, 4, or even 9999.

### Breadcrumbs

Bootstrap3 breadcrumbs can be generated based on a given menu and page.

```ruby
= render_breadcrumb(menu, page)
```

where menu is an `Effective::Menu` object, or the name of a menu, `'main menu'` and page is an `Effective::Page` object, or a string.


## Authorization

All authorization checks are handled via the config.authorization_method found in the `config/initializers/effective_pages.rb` file.

It is intended for flow through to CanCan or Pundit, but neither of those gems are required.

This method is called by all controller actions with the appropriate action and resource

Action will be one of [:index, :show, :new, :create, :edit, :update, :destroy]

Resource will the appropriate Effective::Page object or class

The authorization method is defined in the initializer file:

```ruby
# As a Proc (with CanCan)
config.authorization_method = Proc.new { |controller, action, resource| authorize!(action, resource) }
```

```ruby
# As a Custom Method
config.authorization_method = :my_authorization_method
```

and then in your application_controller.rb:

```ruby
def my_authorization_method(action, resource)
  current_user.is?(:admin) || EffectivePunditPolicy.new(current_user, resource).send('#{action}?')
end
```

or disabled entirely:

```ruby
config.authorization_method = false
```

If the method or proc returns false (user is not authorized) an Effective::AccessDenied exception will be raised

You can rescue from this exception by adding the following to your application_controller.rb:

```ruby
rescue_from Effective::AccessDenied do |exception|
  respond_to do |format|
    format.html { render 'static_pages/access_denied', :status => 403 }
    format.any { render :text => 'Access Denied', :status => 403 }
  end
end
```

### Permissions

The permissions you actually want to define are as follows (using CanCan):

```ruby
can [:show], Effective::Page

if user.is?(:admin)
  can :manage, Effective::Page
  can :manage, Effective::Menu
end
```


## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

Code and Effect is the product arm of [AgileStyle](http://www.agilestyle.com/), an Edmonton-based shop that specializes in building custom web applications with Ruby on Rails.


## Testing

Run tests by:

```ruby
guard
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request


