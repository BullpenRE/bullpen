Rails.application.routes.draw do
  if defined?(ActiveAdmin)
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  get '/freelancer_style', to: 'style#freelancer'
  get '/employer_style', to: 'style#employer'
  get '/login_style', to: 'style#login'
  get '/employer_jobs_style', to: 'style#employer_jobs'

  get '/join', to: 'join#index'

  devise_for :users, controllers: {
    passwords: 'passwords',
    registrations: 'registrations'
  }

  devise_scope :user do
    get '/password_reset', to: 'passwords#password_reset'
    get '/employer_sign_up', to: 'registrations#employer_sign_up'
    get '/freelancer_sign_up', to: 'registrations#freelancer_sign_up'
  end

  resources :avatar, only: %i[update destroy]
  resources :freelancer_profile_steps
  resources :employer_profile_steps

  # resources :employer

  namespace :employer do
    get 'dashboard', to: 'dashboard#show'
    resources :jobs
    resources :job_flows
    resources :billing
    resources :refer
    resources :talent
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/check_users_email', to: 'check_email#check_users_email'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  if Rails.env.test?
    namespace :test do
      post 'clean_database', to: 'databases#clean_database'
      post 'seed_posts', to: 'seeds#seed_posts'
    end
  end

  get '/styleguide', to: 'styleguide#index'

  root 'join#index'

end
