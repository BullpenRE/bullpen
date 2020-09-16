Rails.application.routes.draw do
  get '/join', to: 'join#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  if Rails.env.test?
    namespace :test do
      post 'clean_database', to: 'databases#clean_database'
      post 'seed_posts', to: 'seeds#seed_posts'
    end
  end

  root 'join#index'

end
