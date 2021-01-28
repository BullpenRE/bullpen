require 'sidekiq/web'
Sidekiq::Web.set :sessions, false
Sidekiq.default_worker_options = {backtrace: true}
