module ViewInspect
  module Handlers
    module Haml

      def self.augment_source
        return unless haml_installed?

        ::Haml::Compiler.class_eval do
          alias_method :orig_compile, :compile

          def compile(node)
            if node.type == :tag
              file_line = [@options[:filename], node.line].join(":")
              node.value[:attributes].merge!(:data => { :orig_file_line => file_line })
            end
            orig_compile(node)
          end
        end
      end

      def self.haml_installed?
        defined? ::Haml::Compiler
      end

    end
  end
end

