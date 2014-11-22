require 'view_inspect/server_side_template'
require 'view_inspect/client_side_template'

module ViewInspect

  def self.init
    return unless allow_view_source_location?

    ServerSideTemplate.handle
    ClientSideTemplate.handle

    @show_html_syntax_error = false
  end

  def self.allow_view_source_location?
    !@disable && ::Rails.env.development?
  end

  def self.disable=(bool)
    @disable = bool
  end

  def self.show_html_syntax_error?
    @show_html_syntax_error
  end

  def self.show_html_syntax_error=(bool)
    @show_html_syntax_error = bool
  end

end

require 'view_inspect/rails/railtie'
