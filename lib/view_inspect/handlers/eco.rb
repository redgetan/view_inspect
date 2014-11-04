require 'view_inspect/handlers/html_template'

module ViewInspect
  module Handlers
    class Eco < HTMLTemplate
      def self.expression_regex
        /(<%(=+|-|\#|%)?(.*?)([-=])?%>([ \t]*)?)/m # same as erb
      end
    end
  end
end
