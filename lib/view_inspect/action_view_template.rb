require 'view_inspect/handlers/erb'
require 'view_inspect/handlers/haml'

module ViewInspect
  module ActionViewTemplate

    def self.handle_server_side_templates
      Handlers::Haml.augment_source

      ::ActionView::Template.class_eval do
        alias_method :orig_initialize, :initialize

        # ActionView Template Resolver uses File.binread to read views
        # thus making ASCII-8BIT (alias for binary) the default encoding.
        #
        # libxml2 which nokogiri uses doesnt support ASCII-8BIT encoding.
        # That's why we need to encode first before letting nokogiri parse
        # html fragment and add file:line information to DOM nodes
        def initialize(source, identifier, handler, details)
          orig_initialize(source, identifier, handler, details)

          if handler.respond_to? :erb_implementation
            encode!
            @source = Handlers::ERB.new.add_file_line_to_html_tags(@source, identifier)
          end
        end
      end
    end

  end
end
