Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'welcome#index'
  root 'surveys#index'

  resources :surveys do
    resources :mcqs, only: [:new, :create, :destroy]
    resources :nrqs, only: [:new, :create, :destroy]
    resources :responses, only: [:new, :create]
  end

end
