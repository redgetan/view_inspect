module ViewInspect
  module Handlers
    module Slim

      def self.augment_source
        return unless slim_installed?

        ::Slim::Parser.class_eval do
          alias_method :orig_parse_attributes, :parse_attributes

          def parse_attributes(attributes)
            orig_parse_attributes(attributes)
            file_line = [@options[:file], @lineno].join(":")
            attribute = [:html, :attr, "data-orig-file-line", [:escape, true, [:slim, :interpolate, file_line]]]
            attributes << attribute
          end
        end
      end

      def self.slim_installed?
        defined? ::Slim::Parser
      end

    end
  end
end

