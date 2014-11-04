require 'view_inspect/handlers/html_template'

module ViewInspect
  module Handlers
    class Handlebars < HTMLTemplate
      def self.expression_regex
        /\{\{+.*?\}\}+/m
      end
    end
  end
end
