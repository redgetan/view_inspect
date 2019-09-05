require 'view_inspect/server_side_template'
require 'view_inspect/client_side_template'

module ViewInspect

  def self.init
    return unless allow_view_source_location?

    @show_line_number = true
    ServerSideTemplate.handle
    ClientSideTemplate.handle
  end

  def self.allow_view_source_location?
    !@disable && ::Rails.env.development?
  end

  def self.disable=(bool)
    @disable = bool
  end

  def self.max_path_depth=(depth)
    @max_path_depth = depth
  end

  def self.max_path_depth
    @max_path_depth && @max_path_depth >= 0 ? @max_path_depth : 0
  end

  def self.show_line_number?
    @show_line_number
  end

  def self.show_line_number=(bool)
    @show_line_number = bool
  end

  def self.show_html_syntax_error?
    @show_html_syntax_error
  end

  def self.show_html_syntax_error=(bool)
    @show_html_syntax_error = bool
  end

end

require 'view_inspect/rails/railtie'
