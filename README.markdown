View Inspect
============

View Inspect shows you the exact file and line number of the server-side or client-side template that's responsible for rendering a DOM element. Instead of using grep to filter through a large codebase, the source location can be found right away in its data-attribute when you open up web inspector. Works with Rails 3 and 4. See below for templates supported and their required libraries.

Demo
----
- [Diaspora:   Haml + Backbone.js](https://i.imgur.com/bhK6lap.png)
- [Discourse:  ERB + Ember.js + Handlebars](http://i.imgur.com/mD7sQ2m.png)

Support
----
| Template                | Required Library       |
| ----------------------- | ---------------------- |
| Haml                    | haml                   |
| Slim                    | slim                   |
| ERB                     | any erb implementation |
| Handlebars              | ember-rails, handlebars_assets          |
| EJS                     | sprockets              |
| JST                     | sprockets              |
| Eco                     | sprockets              |


Installation
----

    group :development do
      gem "view_inspect"
    end

Warning
----

By default, this is only enabled for development to avoid exposing source code filepath information publicly. If you want to disable it in development (i.e you want to benchmark/profile your app), add this line on config/environments/development.rb

    ViewInspect.disable = true

How it Works
----

Except for Haml and Slim where the compiler/parser is monkeypatched, view templates are augmented with source location metadata by preprocessing them with an HTML parser. Basically, we first stub out all template specific expressions (i.e. `<% %>` for erb) from a template file. Then, we use the Nokogiri HTML Parser to parse the resulting valid HTML fragment, and add file:line information to its child nodes. Once this is done, we bring back our original template expressions and remove the stubs. A little bit hacky but it works.


Server-Side Templates
----

If you just want to track file:line origin of server-side templates such as ERB and Haml, you don't have to do anything else. It should just work after enabling it on development.rb

Client-Side Templates
----

For client-side templates to work, they have to live in separate files as opposed to being embedded in script tags. Also, you might need to clear the sprockets cache on initial use and cache directory is usually stored in `tmp/cache/assets`. Alternatively, you can just clear the whole cache via:

    rake tmp:clear

HTML Syntax Errors
----
ViewInspect depends on Nokogiri to preprocess a template and add file:line information to each node. If there's any invalid HTML in your file, Nokogiri would delete it, and sometimes your HTML would look different in the browser because of this. To prevent that from happening, a Warning message would be shown to the user detailing where the HTML syntax errors are located so that the user can remove it. This is the default behavior.

An alternative solution is to avoid adding file:line information to DOM elements whenever Nokogiri encounters HTML syntax errors. Instead, it'll just show the original HTML template. If you prefer this behavior, you can set it by adding this line to config/environments/development.rb

    ViewInspect.show_html_syntax_error = false

Copyright
----

Copyright (c) 2014 Reginald Tan. See LICENSE.txt for
further details.

