# Effective Pages

Content pages and page-specific header tag helpers for your Rails app.

Create content pages ontop of one or more templates -- just regular Rails views -- that you define and control.

Use this gem to create a fully-functional CMS that provides full or restricted editing for your end users.

Built ontop of effective_regions and effective_ckeditor.


## effective_pages 2.0

This is the 2.0 series of effective_pages.

This requires Twitter Bootstrap 4 and Rails 5.1+

Please check out [bootstrap3 branch](https://github.com/code-and-effect/effective_pages/tree/bootstrap3) for more information using this gem with Bootstrap 3.


## Getting Started

Please first install the [effective_regions](https://github.com/code-and-effect/effective_regions) and [effective_datatables](https://github.com/code-and-effect/effective_datatables) gems.

Please download and install [Twitter Bootstrap4](http://getbootstrap.com)

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

Add the following helper to your application layout in the `<head>..</head>` section.  This will properly create `<title>` and `<meta description>` tags based on the Effective::Page and the controller instance variables `@page_title` and `@meta_description` for non Effective::Page routes. It will also create additional Open Graph tags based on the initializer.

```ruby
= effective_pages_header_tags
```

There are no required javascript or stylesheet includes, but you will want to ensure there is an Open Graph compatible image available in your assets folder.


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
  .col
    = effective_region page, :left do
      %p this is default left column content
  .col
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
  can :admin, :effective_pages # Can access the admin screens
end
```

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
