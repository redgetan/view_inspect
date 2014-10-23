require 'view_inspect/erb'
require 'view_inspect/haml'

module ViewInspect
  def self.enable
    return unless ViewInspect.allow_view_source_location?
    ERB.enable
    Haml.enable
  end

  def self.allow_view_source_location?
    if defined?(Rails)
      config[:allow_view_source_location] || Rails.env.development?
    else
      config[:allow_view_source_location] || false
    end
  end

  def self.config
    @config ||= {}
  end

end

require 'view_inspect/railtie' if defined?(Rails)
