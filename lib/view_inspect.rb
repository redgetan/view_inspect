require 'view_inspect/action_view_template'
require 'view_inspect/tilt'
require 'view_inspect/rails/middleware'

module ViewInspect

  def self.init(app)
    return unless allow_view_source_location?

    ActionViewTemplate.handle_server_side_templates
    Tilt.handle_client_side_templates

    if track_javascript?
      app.middleware.use ViewInspect::Middleware
    end
  end

  def self.allow_view_source_location?
    enabled? && ::Rails.env.development?
  end

  def self.enable=(bool)
    @enable = bool
  end

  def self.enabled?
    @enable
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
