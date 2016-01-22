Rails.application.routes.draw do
  mount InteractionWebTools::Engine => "/interaction_web_tools"

  root 'welcome#index'
end
