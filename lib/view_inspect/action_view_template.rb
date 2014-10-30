require 'view_inspect/handlers/erb'
require 'view_inspect/handlers/haml'

module ViewInspect
  module ActionViewTemplate

    def self.augment_source
      handle_haml
      handle_erb
    end

    def self.handle_haml
      Handlers::Haml.augment_source
    end

    def self.handle_erb
      ::ActionView::Template.class_eval do
        alias_method :orig_initialize, :initialize

        def initialize(source, identifier, handler, details)
          orig_initialize(source, identifier, handler, details)

          if handler.respond_to? :erb_implementation
            # ActionView Template Resolver uses File.binread to read views
            # thus making ASCII-8BIT (alias for binary) the default encoding.
            #
            # libxml2 which nokogiri uses doesnt support ASCII-8BIT encoding.
            # That's why we need to encode first before letting nokogiri parse
            # html fragment and add file:line information to DOM nodes
            encode!
            @source = Handlers::ERB.new.add_file_line_to_html_tags(@source, identifier)
          end
        end
      end
    end

  end
end
