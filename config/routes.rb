Gpx::Application.routes.draw do
  resources :segments, :only => [:index, :update, :destroy] do
    resources :points, :only => :index
  end

  resources :uploads, :only => :create
  resources :history, :only => :index

  root :to => 'segments#index'
end
