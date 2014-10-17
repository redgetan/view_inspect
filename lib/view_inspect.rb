require 'view_inspect/erb'
require 'view_inspect/haml'

module ViewInspect
  def self.enable
    return unless allow_view_source_location?

    ERB.enable
    Haml.enable
  end

  def self.allow_view_source_location?
    if defined?(Rails)
      !Rails.env.production?
    else
      true
    end
  end

end

require 'view_inspect/railtie' if defined?(Rails)
