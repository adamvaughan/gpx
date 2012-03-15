Gpx::Application.routes.draw do
  resources :segments, :path => 'rides', :only => [:index, :show] do
    resources :points, :only => :index
  end

  resource :upload, :only => [:show, :create]
  match '/reports/totals' => 'reports#totals'

  root :to => 'segments#index'
end
