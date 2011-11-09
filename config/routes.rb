Gpx::Application.routes.draw do
  resources :segments, :only => [:index, :update] do
    resources :points, :only => :index
  end

  resources :uploads, :only => :create

  root :to => 'segments#index'
end
