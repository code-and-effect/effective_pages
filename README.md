# Effective Pages

Rise of the effective page!!

This is a work in progress gem that's ALMOST ready for release

TODO: Make a README!

effective_pages.page_url
effective_pages.page_path


No javascript to add for Pages

Put

= effective_page_header_tags

in your header, so the page title and meta-description can be saved


If you want to use regular maxDepth == 2 bootstrap3 menus, no CSS to add

if you want deep menus, you can add

@import 'effective_pages'; for unlimitted depth bootstrap3 menus addon

then call = render_menu('main menu', :maxdepth => 3)


