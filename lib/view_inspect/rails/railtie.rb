module ViewInspect
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "view_inspect_railtie.configure_rails_initialization" do |app|
        ViewInspect.init
      end
    end
  end
end

