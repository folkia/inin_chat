InteractiveWebTools::Engine.routes.draw do
  resources :events, only: [:index, :create], defaults: { format: :json }
end
