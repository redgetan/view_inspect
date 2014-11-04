require 'nokogiri'

module ViewInspect
  module Handlers
    class HTMLTemplate

      STUB_PREFIX = "<!--template_expression_stub"
      STUB_SUFFIX = "-->"

      def initialize
        @expression_stub_map = {}
      end

      def self.expression_regex
        raise "must be implemented by subclass"
      end

      def add_file_line_to_html_tags(source, filepath)

        doctype = preserve_doctype(source)
        source = replace_expression_with_stub(source)
        source = add_file_line(source, filepath)
        source = replace_stub_with_expression(source)
        source = add_doctype_if_missing(source, doctype)

        source
      end

      def preserve_doctype(source)
        first_line = source.lines.first
        first_line =~ /DOCTYPE/ ? first_line : ""
      end

      def add_doctype_if_missing(source, doctype)
        first_line = source.lines.first
        first_line =~ /DOCTYPE/ ? source : source.insert(0,doctype)
      end

      def add_file_line(source, filepath)
        doc = if source =~ /<\/html>/
                ::Nokogiri::HTML(source)
              else
                ::Nokogiri::HTML.fragment(source)
              end

        doc.traverse do |node|
          if node.is_a?(::Nokogiri::XML::Element)
            file_line = [filepath, node.line].join(":")
            node.set_attribute "data-orig-file-line", file_line
          end
        end

        CGI.unescapeHTML(doc.inner_html)
      end

      def replace_expression_with_stub(source)
        source.gsub(self.class.expression_regex).with_index do |match, index|
          stub = "#{STUB_PREFIX}#{index}#{STUB_SUFFIX}"
          @expression_stub_map[stub] = match
          stub
        end
      end

      def replace_stub_with_expression(source)
        @expression_stub_map.inject(source) do |result, (stub, expression)|
          result = result.sub(stub, expression)
        end
      end

    end
  end
end
