Gpx::Application.routes.draw do
  resources :segments, :only => [:index, :update, :destroy] do
    resources :points, :only => :index
  end

  resources :uploads, :only => :create
  match '/reports/totals' => 'reports#totals'
  match '/reports/monthly' => 'reports#monthly'
  match '/records' => 'records#show'

  root :to => 'segments#index'
end
