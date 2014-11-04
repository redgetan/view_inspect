require 'view_inspect/action_view_template'
require 'view_inspect/tilt'
require 'view_inspect/rails/middleware'

module ViewInspect
  def self.enable(app)
    return unless allow_view_source_location?

    ActionViewTemplate.handle_server_side_templates
    Tilt.handle_client_side_templates

    if track_javascript?
      app.middleware.use ViewInspect::Middleware
    end
  end

  def self.allow_view_source_location?
    ::Rails.env.development?
  end

  def self.enable_javascript_tracking!
    @track_javascript = true
  end

  def self.track_javascript?
    @track_javascript
  end

end

require 'view_inspect/rails/railtie'
