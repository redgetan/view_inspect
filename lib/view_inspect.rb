require 'view_inspect/server_side_template'
require 'view_inspect/client_side_template'
require 'view_inspect/rails/middleware'

module ViewInspect

  def self.init(app)
    return unless allow_view_source_location?

    ServerSideTemplate.handle
    ClientSideTemplate.handle

    if track_javascript?
      app.middleware.use ViewInspect::Middleware
    end

    @show_html_syntax_error = true
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

  def self.enable_javascript_tracking!(*library_exclude_list)
    @track_javascript = true
    @library_exclude_list = library_exclude_list.flatten
  end

  def self.track_javascript?
    @track_javascript
  end

  def self.library_exclude_list
    Array(@library_exclude_list)
  end

end

require 'view_inspect/rails/railtie'
