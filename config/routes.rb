Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :new, only: :index # Testing purposes only

  # mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
