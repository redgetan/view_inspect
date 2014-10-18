require 'view_inspect/middleware'

module ViewInspect
  class Railtie < Rails::Railtie
    initializer "view_inspect_railtie.configure_rails_initialization" do |app|
      if ViewInspect.allow_view_source_location?
        ViewInspect.enable
        app.middleware.use ViewInspect::Middleware
      end
    end
  end
end
