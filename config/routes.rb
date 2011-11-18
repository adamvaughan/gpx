Gpx::Application.routes.draw do
  resources :segments, :only => [:index, :update, :destroy] do
    resources :points, :only => :index
  end

  resources :uploads, :only => :create
  match '/report' => 'reports#show'
  match '/records' => 'records#show'

  root :to => 'segments#index'
end
