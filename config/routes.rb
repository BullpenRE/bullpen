Rails.application.routes.draw do
  get '/join', to: 'join#index'

  devise_for :users, controllers: {
    passwords: 'passwords',
    registrations: 'registrations'
  }

  devise_scope :user do
    get '/password_reset', to: 'passwords#password_reset'
  end

  resources :registration_steps
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/check_users_email', to: 'check_email#check_users_email'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  if Rails.env.test?
    namespace :test do
      post 'clean_database', to: 'databases#clean_database'
      post 'seed_posts', to: 'seeds#seed_posts'
    end
  end

  root 'join#index'

end
