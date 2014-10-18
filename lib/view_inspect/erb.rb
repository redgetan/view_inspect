require 'nokogiri'

module ViewInspect
  module ERB
    # from erubis 2.7.0
    #DEFAULT_REGEX = /(<%(=+|-|\#|%)?(.*?)([-=])?%>([ \t]*\r?\n)?)/m

    ERB_REGEX_EXCLUDE_ENDING_NEWLINE = /(<%(=+|-|\#|%)?(.*?)([-=])?%>([ \t]*)?)/m
    ERB_STUB = "__erb_stub_placement___"

    @erb_orig_list = []

    def self.enable
      ActionView::Template.class_eval do
        alias_method :orig_source, :source

        def source
          return orig_source unless handler.respond_to? :erb_implementation
          ::ViewInspect::ERB.add_file_line_to_html_tags(orig_source, identifier)
        end
      end
    end

    def self.add_file_line_to_html_tags(source, filepath)

      source = replace_erb_with_stub(source)
      source = add_file_line(source, filepath)
      source = replace_stub_with_erb(source)

      source
    end

    def self.add_file_line(source, filepath)
      doc = ::Nokogiri::HTML(source)

      doc.traverse do |node|
        if node.is_a?(::Nokogiri::XML::Element)
          file_line = [filepath, node.line].join(":")
          node.set_attribute "data-orig-file-line", file_line
        end
      end

      doc.inner_html
    end

    def self.replace_erb_with_stub(source)
      @erb_orig_list = source.scan(ERB_REGEX_EXCLUDE_ENDING_NEWLINE).map { |a,b,c,d,e| a }
      source.gsub(ERB_REGEX_EXCLUDE_ENDING_NEWLINE,ERB_STUB)
    end

    def self.replace_stub_with_erb(source)
      source.gsub(ERB_STUB).with_index do |match, index|
        @erb_orig_list[index]
      end
    end

  end
end
