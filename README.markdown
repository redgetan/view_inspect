= View Inspect

View Inspect shows you the source location of a client or server rendered DOM element. It currently only works for Rails where erb and haml templates are supported. For client rendered DOM, only basic javascript/jQuery is supported

== Demo

== Installation

    group :development do
      gem "view_inspect"
    end

To enable javascript DOM source location tracking, you need to specify external libraries you wish to prevent from showing up as a potential source location. This is because of the way we track the origin of client-side DOM insertion. See How it Works to understand why.

    <head data-orig-exclude-list="jquery,backbone">

== How it Works

For server-rendered DOM elements, we monkey patch view template generation to include the file and line information in the html nodes.

For client-rendered DOM elements, we intercept the native DOM insertion methods such as `appendChild`, `insertBefore`, or `replaceChild`, look at the stacktrace, and go through it to find the most recent caller that includes our javascript code.



== Warning

Don't run this on production. Preferably, you should only run this locally, not even on staging environments. View Inspect shows you the fullpath of your and back-end and front-end code. That is unless you dont mind people seeing things like /home/nandato/rails/app/releases/20131012158211/app/views/ganbatte/show.html.erb:2 in the HTML source


== Copyright

Copyright (c) 2014 Reginald Tan. See LICENSE.txt for
further details.

