Gpx::Application.routes.draw do
  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '' do
    resources :segments, :only => [:index, :update, :destroy] do
      resources :points, :only => :index
    end

    resources :uploads, :only => :create
    match '/reports/totals' => 'reports#totals'
    match '/reports/monthly/distance' => 'reports#monthly_distance'
    match '/reports/monthly/duration' => 'reports#monthly_duration'
    match '/reports/annual/distance' => 'reports#annual_distance'
    match '/reports/annual/duration' => 'reports#annual_duration'
    match '/records' => 'records#show'

    root :to => 'segments#index'
  end
end
