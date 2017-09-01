Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'teachers#index'

  resources :teachers, only: [:index, :show] do
    resources :courses, only: [:index, :show]
  end
end
