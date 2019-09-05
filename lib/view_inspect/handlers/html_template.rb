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

        return source if doc.errors.count > 0 && !ViewInspect.show_html_syntax_error?

        doc.traverse do |node|
          if node.is_a?(::Nokogiri::XML::Element)
            file_line = [filepath.split(File::SEPARATOR)[-ViewInspect.max_path_depth..-1].join(File::SEPARATOR)]
            file_line << node.line if ViewInspect.show_line_number?
            node.set_attribute "data-orig-file-line".freeze, file_line.join(':'.freeze)
          end
        end

        source = CGI.unescapeHTML(doc.inner_html)

        if doc.errors.length > 0
          error_msg = build_html_syntax_error_msg(doc.errors, filepath)
          "#{error_msg}#{source}"
        else
          source
        end
      end

      def build_html_syntax_error_msg(errors, filepath)
        errors_list = errors.inject("") do |result, error|
          result << "<li>line #{error.line} - #{error.to_s}</li>"
          result
        end

        "<div id='view_inspect_error_message' style='border: solid 1px black; z-index: 9999; position: absolute; margin-left: 200px; width: 800px; padding: 20px; background-color: rgb(255, 229, 229); color: black;'>
          <h3 style='font-size: 20px; line-height: 30px; font-weight: bold; background-color: lightgray; padding: 5px; display: inline-block; border: solid 1px black;'>Please correct HTML syntax errors in #{filepath}</h3>
          <ul>#{errors_list}</ul>
        </div>"
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
