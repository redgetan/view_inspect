View Inspect
============

Shows you the source location of a server-side or client-side rendered DOM element. Works with Rails 3 and 4. Server side templates supported include Haml and Erb. Client-side templates support for Handlebars, EJS and Eco only works if the templates live in their own files as opposed to being embedded in javascript code and if the required libraries are installed.

Demo
----


Support
----
| Server-side template    | Required Library       |
| ----------------------- | ---------------------- |
| Haml                    | haml                   |
| ERB                     | any erb implementation |


| Server-side template    | Required Library       |
| ----------------------- | ---------------------- |
| Handlebars              | ember-rails            |
| EJS                     | sprockets              |
| Eco                     | sprockets              |


Installation
----

    group :development do
      gem "view_inspect"
    end

How it Works
----

For Haml, the compiler is monkey patched to include the source file and line information on each node. For ERB, EJS, Eco, Handlebars, we modify the original source by first stubbing out all template specific expressions (i.e. `<% %>` for erb) so that it becomes a valid html document. Then, nokogiri parses it and adds file and line information to each DOM node. Afterwards, we replace the stubs with the original template expressions.

Notice
----

By default, this is only enabled for development to avoid exposing source code details publicly.


Copyright
----

Copyright (c) 2014 Reginald Tan. See LICENSE.txt for
further details.

