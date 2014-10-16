module ViewInspect
  class Railtie < Rails::Railtie
    initializer "view_inspect_railtie.configure_rails_initialization" do
      ViewInspect.enable  
    end
  end
end