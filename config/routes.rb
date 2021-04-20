require 'sidekiq/web'

Rails.application.routes.draw do
  if defined?(ActiveAdmin)
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  default_url_options protocol: ActionMailer::Base.default_url_options[:protocol],
                      host: ActionMailer::Base.default_url_options[:host]

  match '/404', to: 'errors#not_found', via: :all
  get '/talent_not_found', to: 'errors#talent_not_found'
  get '/job_not_found', to: 'errors#job_not_found'
  get '/freelancer_style', to: 'style#freelancer'
  get '/employer_style', to: 'style#employer'
  get '/employer_talent_style', to: 'style#employer_talent'
  get '/login_style', to: 'style#login'
  get '/employer_jobs_style', to: 'style#employer_jobs'

  get '/join', to: 'join#index'
  post '/join/signup', to: 'join#signup'

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

  resources :freelancer_profile_steps
  resources :employer_profile_steps
  resources :users, only: :update

  # resources :employer

  namespace :employer do
    resources :jobs
    get 'post_job', to: 'jobs#post_job'
    resources :job_flows
    resources :interviews
    resources :billing
    resources :refer
    resources :talent
    resources :account, only: %i[index update destroy]
    resource :avatar, only: %i[update destroy]
    resource :profile, only: :update
    resource :timesheets, only: :update
    resources :contracts
    post 'interview_request', to: 'talent#interview_request'
    post 'like_job_application', to: 'jobs#like_job_application'
    post 'send_message', to: 'jobs#send_message'
    post 'decline_job_application', to: 'jobs#decline_job_application'
    post 'withdraw_request', to: 'interviews#withdraw_request'
    post 'make_an_offer', to: 'jobs#make_an_offer'
    post 'remove_interview_request', to: 'interviews#remove_interview_request'
    post 'withdraw_offer', to: 'contracts#withdraw_offer'
    post 'save_review', to: 'reviews#save_review'
    post 'make_an_offer_without_job', to: 'contracts#make_an_offer_without_job'
    post 'find_job', to: 'contracts#find_job'
    post 'close_contract', to: 'contracts#close_contract'
    post 'delete_contract', to: 'contracts#delete_contract'
    get 'show_payment_method', to: 'contracts#show_payment_method'
    post '/stripe/create_card', to: 'stripe#create_card', as: :create_card
    post '/stripe/create_account', to: 'stripe#create_account', as: :create_account
  end

  namespace :public do
    get 'freelancer_profile/:slug', to: 'freelancer_profile#show', as: 'freelancer_profile'
    get 'job/:slug', to: 'job#show', as: 'job'
    get 'apply_for_job', to: 'job#apply_for_job'
    get 'request_interview', to: 'freelancer_profile#request_interview'
    get 'turn_off_new_job_alerts', to: 'freelancer_profile#turn_off_new_job_alerts'
    get 'write_a_review', to: 'freelancer_profile#write_a_review'
    get 'view_contract', to: 'freelancer_profile#view_contract'
  end

  namespace :freelancer do
    resources :jobs
    resources :applications
    resources :application_flows
    put 'application_flows/:job_app/add_work_samples',
        to: 'application_flows#add_work_samples',
        as: 'add_work_samples'
    post 'application_flows/:job_app/destroy_work_sample',
         to: 'application_flows#destroy_work_sample',
         as: 'destroy_work_sample'
    post 'application_flows/:job_app/add_cover_letter',
         to: 'application_flows#add_cover_letter',
         as: 'add_cover_letter'
    resources :interviews
    resources :contracts
    resources :profile, only: :index
    resources :account, only: :index
    resources :billings, only: :destroy
    get '/account/stripe_data_lookup', to: 'account#stripe_data_lookup', as: :stripe_data_lookup
    get '/stripe/connect', to: 'stripe#connect', as: :stripe_connect
    get '/stripe/dashboard', to: 'stripe#dashboard', as: :stripe_dashboard

    resource :avatar, only: %i[update destroy]
    post 'set_withdrawn', to: 'applications#set_withdrawn'
    post 'change_software_licence', to: 'profile#change_software_licence'
    post 'change_certifications', to: 'profile#change_certifications'
    post 'add_certifications', to: 'profile#change_certifications'
    post 'change_skills', to: 'profile#change_skills'
    post 'change_educations', to: 'profile#change_educations'
    post 'add_educations', to: 'profile#change_educations'
    post 'decline_interview', to: 'interviews#decline_interview'
    post 'remove_interview_request', to: 'interviews#remove_interview_request'
    post 'accept_request', to: 'interviews#accept_request'
    post 'send_message', to: 'interviews#send_message'
    post 'change_freelancer_basic_info', to: 'profile#change_freelancer_basic_info'
    post 'add_work_experience', to: 'profile#change_work_experience'
    post 'change_work_experience', to: 'profile#change_work_experience'
    post 'decline_offer', to: 'contracts#decline_offer'
    post 'accept_offer', to: 'contracts#accept_offer'
    post 'close_contract', to: 'contracts#close_contract'
    post 'delete_contract', to: 'contracts#delete_contract'
    post 'update_hours', to: 'billings#update_hours'

    namespace :profile do
      resource :preferences, only: :update
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/check_users_email', to: 'check_email#check_users_email'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  if Rails.env.test?
    namespace :test do
      post 'clean_database', to: 'databases#clean_database'
      post 'seed_posts', to: 'seeds#seed_posts'
      post 'factories', to: 'factories#create'
    end
  end

  get '/styleguide', to: 'styleguide#index'

  root 'join#index'
  authenticate :user, ->(u) { u.bullpen_personnel? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
