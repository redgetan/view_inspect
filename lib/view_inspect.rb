require 'view_inspect/action_view_template'

module ViewInspect
  def self.enable(app = nil)
    return unless allow_view_source_location?
    ActionViewTemplate.augment_source
  end

  def self.allow_view_source_location?
    ::Rails.env.development?
  end

end

require 'view_inspect/rails/railtie'
