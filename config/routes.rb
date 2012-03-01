Gpx::Application.routes.draw do
  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '' do
    resources :segments, :path => 'rides', :only => [:index, :show]

    root :to => 'summary#index'
  end
end
