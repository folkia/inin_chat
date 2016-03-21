InteractionWebTools::Engine.routes.draw do
  resources :events, only: [:index, :create], defaults: { format: :json } do
    collection do
      delete :destroy
    end
  end
end
