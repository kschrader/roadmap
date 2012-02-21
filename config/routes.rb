Roadmap::Application.routes.draw do
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

  root to: 'features#index'

  put 'run_schedule', controller: 'features', action: :run_schedule
  put 'run_refresh', controller: 'refresh', action: :run_refresh
  get 'refresh', controller: 'refresh', action: :refresh

  resources :features do
    get 'tagged/:value',
      :constraints => { :value =>  /[^\/]+/ },
      on: :collection, 
      action: :tagged,
      as: 'tagged'
  end

end
