require 'view_inspect/handlers/html_template'

module ViewInspect
  module Handlers
    class ERB < HTMLTemplate
      def self.expression_regex
        /(<%(=+|-|\#|%)?(.*?)([-=])?%>([ \t]*)?)/m  # from erubis 2.7.0  #DEFAULT_REGEX = /(<%(=+|-|\#|%)?(.*?)([-=])?%>([ \t]*\r?\n)?)/m
      end
    end
  end
end
