Gpx::Application.routes.draw do
  resources :segments, :only => [:index, :show, :edit, :update] do
    resources :points, :only => :index, :constraints => { :format => 'application/json' }
  end

  resources :uploads, :only => :create

  root :to => 'segments#index'
end
