require 'view_inspect/handlers/handlebars'
require 'view_inspect/handlers/ejs'
require 'view_inspect/handlers/eco'

# Were monkey patching subclasses of Tilt::Template to add file:line information to the original source
module ViewInspect
  module ClientSideTemplate

    def self.handle
      class_handler_map.each do |klass, handler|
        klass.class_eval do
          alias_method :orig_initialize, :initialize

          def initialize(file=nil, line=1, options={}, &block)
            orig_initialize(file, line, options, &block)
            handler = ViewInspect::ClientSideTemplate.class_handler_map[self.class]
            @data = handler.new.add_file_line_to_html_tags(@data, file.to_s)
          end
        end
      end
    end

    # only works for sublcasses of Tilt::Template
    def self.class_handler_map
      hash = {}
      hash[::Ember::Handlebars::Template] = Handlers::Handlebars if defined? ::Ember::Handlebars::Template
      hash[::HandlebarsAssets::TiltHandlebars] = Handlers::Handlebars if defined? ::HandlebarsAssets::TiltHandlebars
      hash[::Sprockets::EjsTemplate]      = Handlers::EJS        if defined? ::Sprockets::EjsTemplate
      hash[::Sprockets::EcoTemplate]      = Handlers::Eco        if defined? ::Sprockets::EcoTemplate
      hash
    end

  end
end
