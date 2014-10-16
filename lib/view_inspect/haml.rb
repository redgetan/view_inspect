module ViewInspect
  module Haml
    def self.enable
      return unless haml_installed?

      Haml::Compiler.instance_eval do
        alias_method :orig_compile, :compile

        def compile(node)
          if node.type == :tag
            file_line = [@options[:filename], node.line].join(":")
            node.value.attributes.merge!(:data => { :orig_file_line => file_line })
          end
          orig_compile(node)
        end
      end
    end

    module_function :enable

    def haml_installed?
      defined? Haml::Compiler
    end
  end
end

