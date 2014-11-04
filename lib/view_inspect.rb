require 'view_inspect/action_view_template'
require 'view_inspect/tilt'

module ViewInspect
  def self.enable(app = nil)
    return unless allow_view_source_location?

    ActionViewTemplate.handle_server_side_templates
    Tilt.handle_client_side_templates
  end

  def self.allow_view_source_location?
    ::Rails.env.development?
  end

end

require 'view_inspect/rails/railtie'
