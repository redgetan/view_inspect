= View Inspect

View Inspect is a ruby library that shows you the source location of a client or server rendered DOM element. Works with ERB, Haml, Liquid, Mustache, Handlebars, Jade, eco.

== Demo

== Installation

In your gemfile, include the gem in development group

    group :development do
      gem "view_inspect"
    end

Anywhere in your code, specify where your view templates are located at. For example for Rails, you can put it in `config/initializers/view_inspect.rb`

    ViewInspect.config.template_paths = ["app/views"]
    ViewInspect.config.allow_view_source_location = true

== Usage

  If you're using Rails, it'll automatically be enabled if you're in development. If your using Sinatra, call `ViewInspect.enable` anywhere in your code.

== How it Works


== Warning

Don't run this on production. Preferably, you should only run this locally. View Inspect shows you the fullpath of your and back-end and front-end code. That is unless you dont mind people seeing things like /home/nandato/rails/app/releases/20131012158211/app/views/ganbatte/show.html.erb:2 in the HTML source


== Copyright

Copyright (c) 2014 Reginald Tan. See LICENSE.txt for
further details.

