Rails.application.routes.draw do
  if defined?(ActiveAdmin)
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  default_url_options protocol: ActionMailer::Base.default_url_options[:protocol],
                      host: ActionMailer::Base.default_url_options[:host]

  get '/freelancer_style', to: 'style#freelancer'
  get '/employer_style', to: 'style#employer'
  get '/employer_talent_style', to: 'style#employer_talent'
  get '/login_style', to: 'style#login'
  get '/employer_jobs_style', to: 'style#employer_jobs'

  get '/join', to: 'join#index'

  devise_for :users, controllers: {
    passwords: 'passwords',
    registrations: 'registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    confirmations: 'confirmations'
  }

  devise_scope :user do
    get '/password_reset', to: 'passwords#password_reset'
    get '/employer_sign_up', to: 'registrations#employer_sign_up'
    get '/freelancer_sign_up', to: 'registrations#freelancer_sign_up'
  end

  get '/promo/:promo_code', to: 'signup_promos#show'

  resources :avatar, only: %i[update destroy]
  resources :work_sample, only: :update
  post '/work_sample/destroy', to: 'work_sample#destroy_work_sample'
  resources :freelancer_profile_steps
  resources :employer_profile_steps

  # resources :employer

  namespace :employer do
    resources :jobs
    get 'post_job', to: 'jobs#post_job'
    resources :job_flows
    resources :interviews
    resources :billing
    resources :refer
    resources :talent
    post 'interview_request', to: 'talent#interview_request'
    post 'like_job_application', to: 'jobs#like_job_application'
  end

  namespace :public do
    get 'freelancer_profile/:slug', to: 'freelancer_profile#show', as: 'freelancer_profile'
    get 'job/:slug', to: 'job#show', as: 'job'
    get 'request_interview', to: 'freelancer_profile#request_interview'
  end

  namespace :freelancer do
    resources :jobs
    resources :applications
    resources :application_flows
    resources :interviews
    resources :contracts
    resources :profile, only: :index
    post 'set_withdrawn', to: 'applications#set_withdrawn'
    post 'change_software_licence', to: 'profile#change_software_licence'
    post 'change_certifications', to: 'profile#change_certifications'
    post 'add_certifications', to: 'profile#change_certifications'
    post 'change_skills', to: 'profile#change_skills'
    post 'change_educations', to: 'profile#change_educations'
    post 'add_educations', to: 'profile#change_educations'
    post 'decline_interview', to: 'interviews#decline_interview'
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
