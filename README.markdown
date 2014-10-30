View Inspect
============

Shows you the source location of a server-side rendered DOM element. Works with Rails 3 and 4. Currently supports Haml, ERB.

Demo
----

Installation
----

    group :development do
      gem "view_inspect"
    end

How it Works
----

For Haml, the compiler is monkey patched to include the source file and line information on each node. For ERB, we modify the original source by first stubbing out all erb expressions (basically anything wrapped in `<% %>`) so that it becomes a valid html document for nokogiri to parse and add file and line information to. Then after adding the source location metadata, we replace the stubs with the original erb expressions.

Notice
----

By default, this is only enabled for development to avoid exposing source code details publicly.


Copyright
----

Copyright (c) 2014 Reginald Tan. See LICENSE.txt for
further details.

