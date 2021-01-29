worker: bundle exec sidekiq -c ${SIDEKIQ_WORKERS:-5} -q critical,5 -q default,2 -q mailers,1 -q active_storage_analysis,1 -q active_storage_purge,1 -v
web: bundle exec puma -C config/puma.rb