require 'view_inspect/erb'
require 'view_inspect/haml'

module ViewInspect
  def enable
    return unless allow_view_source_location?

    ERB.enable
    Haml.enable
  end

  def allow_view_source_location?
    !Rails.env.production
  end

end

require 'view_inspect/railtie' if defined?(Rails)
