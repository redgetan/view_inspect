View Inspect
============

View Inspect tells you which server-side or client-side template is responsible for rendering a DOM element. Instead of using grep to sift through a large codebase to find the source location of a UI, the information can be found right away in its data-attribute when you open up web inspector. Works with Rails 3 and 4. See below for templates supported and their required libraries

Screenshot
----


Support
----
| Template                | Required Library       |
| ----------------------- | ---------------------- |
| Haml                    | haml                   |
| ERB                     | any erb implementation |
| Handlebars              | ember-rails            |
| EJS                     | sprockets              |
| Eco                     | sprockets              |


Installation
----

    group :development do
      gem "view_inspect"
    end


Usage
----

ViewInspect is disabled by default. To enable it, add this line on config/environments/development.rb

    ViewInspect.enable = true

Server-Side Templates
-----

If you just want to track file:line origin of server-side templates such as ERB and Haml, you don't have to do anything else. It should just work after enabling it on development.rb

Client-Side Templates
-----

For client-side templates such as Handlebars, EJS, etc., before using it, you might need to clear the sprockets cache which is usually stored in `tmp/cache/assets`. You can also just clear the whole cache as an alternative via.

    rake tmp:clear

How it works
-----

The basic idea on how this works is that we modify the template source before they are rendered or precompiled. To do that, we stub out all template specific expressions (i.e. `<% %>` for erb) from the original file so that it becomes a valid html document/fragment. Then, we parse the result with Nokogiri, after which we add file and line information to each DOM node. Once the source location metadata has been added as a data-attribute, the stubs are replaced with the original template expressions so that template handlers can compile/evaluate/render it.

This doesnt work for Haml though since its not valid html. Instead, the compiler is monkey patched to include the source file and line information.

Tracking Javascript DOM insertion
----

If you use a lot of javascript/jquery to manually insert DOM elements, you can also enable javascript DOM insertion tracking by adding this line to `config/environments/development.rb`.

    ViewInspect.enable_javascript_tracking!

Then, you need to make sure that in your `config/environments/development.rb`, asset compression is turned off

    config.assets.compress = false

Also, depending which library you're using, you may need to specify external libraries you wish to prevent from showing up as a potential source location. This is because of the way we track the origin of javascript DOM insertion. In order to do that, pass in an array of library names you want to exclude to `enable_javascript_tracking!` . For example:

    ViewInspect.enable_javascript_tracking!([:jquery, :backbone])


The reason why you may need to do this is because of the way we track the javascript file:line. We intercept the native DOM insertion methods such as appendChild, insertBefore, or replaceChild, look at the stacktrace, and then go through it to find the most recent caller which corresponds to our javascript code.

Disable ViewInspect
-----

  If you want to temporarily disable ViewInspect (ie. you want to profile your code and don't want the extra overhead), you can simply set ViewInspect.enable to false in config/environments/development.rb

    ViewInspect.enable = false

Warning
----

By default, this is only enabled for development to avoid exposing source code filepath information publicly.


Copyright
----

Copyright (c) 2014 Reginald Tan. See LICENSE.txt for
further details.

