Roadmap::Application.routes.draw do
  root to: 'features#index'

  resources :features do
    put 'refresh', on: :collection
  end

end
