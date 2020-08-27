Rails.application.routes.draw do
  root to: 'teachers#index'

  resources :teachers, only: [:index, :show] do
    resources :courses, only: [:index, :show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
