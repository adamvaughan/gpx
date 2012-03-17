Gpx::Application.routes.draw do
  namespace :api do
    resources :segments, :path => 'rides', :only => [:index, :show] do
      resources :points, :only => :index
    end

    get 'reports/totals' => 'reports#totals', :as => 'reports_totals'
  end

  resource :upload, :only => :create

  get 'rides' => 'page#index'
  get 'rides/:id' => 'page#index'
  get 'upload' => 'page#index'

  root :to => 'page#index'
end
