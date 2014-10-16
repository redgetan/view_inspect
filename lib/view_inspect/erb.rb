module ViewInspect
  module ERB
    ERB_PREFIX  = "<%"
    ERB_POSTFIX = "%>"
    ERB_PREFIX_STUB = "__erb__stub__start"
    ERB_POSTFIX_STUB = "__erb__stub__end"

    def self.enable
      ActionView::Template.instance_eval do
        def source
          return super unless handler == :erb
          ::ViewInspect::ERB.add_file_line_to_html_tags(super, identifier)
        end
      end
    end

    module_function :enable

    def add_file_line_to_html_tags(source, filepath)

      source = replace_erb_tags_with_stub(source)
      source = add_file_line(source, filepath)
      source = replace_stub_with_erb_tags(source)

      source
    end

    def add_file_line(source, filepath)
      doc = Nokogiri::HTML(source)

      doc.traverse do |node|
        if node.is_a?(Nokogiri::XML::Element)
          file_line = [filepath, node.line].join(":")
          node.set_attribute "data-orig-file-line", file_line
        end
      end

      CGI.unescape(doc.inner_html)
    end

    def replace_erb_tags_with_stub(source)
      source.gsub(ERB_PREFIX, ERB_PREFIX_STUB)
            .gsub(ERB_POSTFIX, ERB_POSTFIX_STUB)
    end

    def replace_stub_with_erb_tags(source)
      source.gsub(ERB_PREFIX_STUB, ERB_PREFIX)
            .gsub(ERB_POSTFIX_STUB, ERB_POSTFIX)
    end

  end
end
