Gpx::Application.routes.draw do
  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '' do
    resources :segments, :path => 'rides', :only => :index do
      resources :points, :only => :index
    end

    root :to => 'segments#index'
  end
end
