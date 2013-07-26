# Effective Pages

A drop-in CMS solution for dynamically creating pages based off pre-defined templates.  Create templates ahead of time (think one_column, two_column..) with defined editable content regions.  Users can create content pages, choose a template, and use the fullscreen in-place editor to set their content.

A full solution for creating, updating and templating content pages in your Rails application.

Write templates that define content regions.

Use the full-page on-screen editor (effective_mercury) to edit content regions.

While not required, the intended use of this gem includes ActiveAdmin (for the CRUD screens)


## Getting Started

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

If you want to tweak the database table name (to use something other than the default 'pages'), manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

Mount the Rails Engine at your desired location

```ruby
mount EffectivePages::Engine => '/', :as => 'effective_pages'
```

If you want the EffectivePages to also handle your root path

```ruby
root :to => 'Effective::Pages#show', :id => 'home'   #  Make sure to create a page with the 'home' slug
```

If you intend to use ActiveAdmin (optional, but highly recommended)

Add to your ActiveAdmin.js file:

```ruby
//= require effective_pages

```

And to your ActiveAdmin stylesheet

```ruby
body.active_admin {
  @import "effective_pages";
}
```

If ActiveAdmin is installed, there will automatically be an 'Effective Pages' page.

## Usage

### Templates

Many applications have 2 or 3 page designs that are reused throughout the site on various content pages.

A template, as used in effective pages, is one of these unique page designs.
The template is rendered like a normal page via the standard 'yield' in your layout, and then inserts page content into the appropriate regions.

Create a template:

Create a normal .html.erb or .html.haml (whatever) in the app/views/templates/ directory.
(This is configurable in the effective_pages.rb initializer)

app/views/templates/two_column.html.haml:

```haml
%h1= page_region :page_title

%div.col1
  %p
    = page_region :column_one do
      Default Column One content if there is no content for :column_one region

%div.col2
  %p= page_region :column_two
```

As long as the file itself exists, the ActiveAdmin Pages#new action will pickup the template and it will be assignable when creating a new Effective Page.
The page will totally work when editting through effective_mercury integration.

However, if you want to add additional information, you must add an entry to the config/effective_pages.yml file:

```ruby
two_column:
  layout: 'application'
  description: 'This is a two-column view'
  regions:
    column_one:
      label: 'Column #1'
      description: 'This is a sidebar'
    column_two:
      label: 'Column #2'
      description: 'This is the main section on the right'
```

### Routing

Whenever an Effective Page is created, a slug will be automatically generated (see effective_slugs).
All pages are routed through the PagesController#show action, and should 'just work'

### Full Screen Editting

If the url for your newly created Page is:  http://localhost:3000/page-one
Then visitting http://localhost:3000/edit/page-one
will bring up the mercury editor, and place you into edit mode.  This is fantastic.

### Authorization

All authorization checks are handled via the config.authorization_method found in the effective_pages.rb initializer.

It is intended for flow through to CanCan, but that is not required.

The authorization method can be defined as:

```ruby
EffectivePages.setup do |config|
  config.authorization_method = Proc.new { |controller, action, resource| can?(action, resource) }
end
```

or as a method:

```ruby
EffectivePages.setup do |config|
  config.authorization_method = :authorize_effective_pages
end
```

and then in your application_controller.rb:

```ruby
def authorize_effective_pages(action, resource)
  can?(action, resource)
end
```

The action will be one of :read, :create, :update, :destroy, :manage
The resource will generally be the @page, but in the case of :manage, it is Effective::Page class.

If the method or proc returns false (user is not authorized) an ActiveResource::UnauthorizedAccess exception will be raised

You can rescue from this exception by adding the following to your application_controller.rb

```ruby
rescue_from ActiveResource::UnauthorizedAccess do |exception|
  respond_to do |format|
    format.html { render 'static_pages/access_denied', :status => 403 }
    format.any { render :text => 'Access Denied', :status => 403 }
  end
end
```

### Helpers

Put the following helper:

```ruby
= effective_page_header_tags
```

into the 'head' section of your layout (application layout, or otherwise) to handle the title, meta description and meta keywords tags.


### Integration

Uses effective_assets to handle inserting uploaded assets.

### Testing
```ruby
effective_pages\spec\dummy > bundle exec rails generate effective_page:install

effective_pages > bundle exec rake app:db:migrate
effective_pages > bundle exec rake app:db:test:prepare

effective_pages > guard
guard> * press enter *
````


## License

MIT License.  Copyright Code and Effect Inc. http://www.codeandeffect.com

You are not granted rights or licenses to the trademarks of Code and Effect
