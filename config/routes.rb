Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/freelancer_style', to: 'style#freelancer'
  get '/employer_style', to: 'style#employer'
  get '/login_style', to: 'style#login'
  get '/join', to: 'join#index'

  devise_for :users, controllers: {
    passwords: 'passwords',
    registrations: 'registrations'
  }

  devise_scope :user do
    get '/password_reset', to: 'passwords#password_reset'
    get '/new_company', to: 'registrations#new_company'
  end

  resources :freelancer_profile_steps
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/check_users_email', to: 'check_email#check_users_email'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  if Rails.env.test?
    require 'test_routes'
    define_test_routes
    namespace :test do
      post 'clean_database', to: 'databases#clean_database'
      post 'seed_posts', to: 'seeds#seed_posts'
    end
  end

  get '/styleguide', to: 'styleguide#index'
  get '/employer', to: 'style#employer'
  get '/freelancer', to: 'style#freelancer'
  get '/login', to: 'style#login'

  root 'join#index'

end
