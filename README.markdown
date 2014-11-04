View Inspect
============

Shows you the source location of a server-side or client-side rendered DOM element. Works with Rails 3 and 4. Server side templates supported include Haml and Erb. Client-side templates support for Handlebars, EJS and Eco only works if the templates live in their own files as opposed to being embedded in javascript code and if the required libraries are installed.

Demo
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

If you're just using ERB and Haml, you don't have to do anything extra, it'll just work.

For client-side templates such as Handlebars, EJS, etc., before using it, you might need to clear the sprockets cache which is usually stored in `tmp/cache/assets`. You can also just clear the whole cache as an alternative via.

    rake tmp:clear

The basic idea on how this works for ERB, EJS, Eco, and Handlebars is that we stub out all template specific expressions (i.e. `<% %>` for erb) from the original source so that it becomes a valid html document. Nokogiri parses it and adds file and line information to each DOM node. Afterwards,the stubs are replaced with the original template expressions.

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

Warning
----

By default, this is only enabled for development to avoid exposing source code details publicly.


Copyright
----

Copyright (c) 2014 Reginald Tan. See LICENSE.txt for
further details.

