Gpx::Application.routes.draw do
  namespace :api do
    resources :rides, :only => [:index, :show] do
      get 'page/:page', :action => :index, :on => :collection
      resources :points, :only => :index
    end

    get 'reports/totals' => 'reports#totals', :as => 'reports_totals'
  end

  resource :upload, :only => :create

  get 'rides' => 'page#index'
  get 'rides/page/:page' => 'page#index'
  get 'rides/:id' => 'page#index'
  get 'upload' => 'page#index'

  root :to => 'page#index'
end
