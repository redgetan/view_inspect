require 'nokogiri'

module ViewInspect
  module Handlers
    class HTMLTemplate

      STUB_PREFIX = "__template_expression_stub__"

      def initialize
        @expression_stub_map = {}
      end

      def self.expression_regex
        raise "must be implemented by subclass"
      end

      def add_file_line_to_html_tags(source, filepath)
        return source if html_layout?(source) # currently dont support html layout templates

        source = replace_expression_with_stub(source)
        source = add_file_line(source, filepath)
        source = replace_stub_with_expression(source)

        source
      end

      def add_file_line(source, filepath)
        doc = ::Nokogiri::HTML.fragment(source)

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
          stub = "#{STUB_PREFIX}#{index}"
          stub = preserve_linecount(stub, match)
          @expression_stub_map[stub] = match
          stub
        end
      end

      def replace_stub_with_expression(source)
        @expression_stub_map.inject(source) do |result, (stub, expression)|
          result = result.sub(stub, expression)
        end
      end

      private

        def html_layout?(source)
          source =~ /<\/html>/
        end

        def preserve_linecount(stub, match)
          newline_padding_count = match.lines.count - 1
          stub + "\n" * newline_padding_count
        end

    end
  end
end
