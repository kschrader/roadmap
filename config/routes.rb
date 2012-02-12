Roadmap::Application.routes.draw do
  root to: 'features#index'

  put 'run_refresh', controller: 'refresh', action: :run_refresh
  get 'refresh', controller: 'refresh', action: :refresh

  resources :features do
    get 'tagged/:value', 
      on: :collection, 
      action: :tagged,
      as: 'tagged'
  end

end
