Roadmap::Application.routes.draw do
  root to: 'projects#index'

  resources :projects do 
    get "billing", controller: 'projects/reports', action: :billing
    get "billing_detail", controller: 'projects/reports', action: :billing_detail
    put 'run_refresh', controller: 'projects/refresh', action: :run_refresh
    get 'refresh', controller: 'projects/refresh', action: :refresh
    post 'schedule', controller: 'features', action: :schedule

    resources :features do
      get 'tagged/:value',
        :constraints => { :value =>  /[^\/]+/ },
        on: :collection, 
        action: :tagged,
        as: 'tagged'
    end

    resources :bundles do 
      post 'add_feature',
        on: :member,
        action: :add_feature,
        as: 'add_feature'
      post 'remove_feature',
        on: :member,
        action: :remove_feature,
        as: 'remove_feature'
    end
  end
end
