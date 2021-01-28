source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'active_storage_validations'            # Validation set for activestorage
gem 'amazing_print', '~> 1.2', '>= 1.2.1'   # Replacement for awesome_print which is depreciated
gem 'bootsnap', '>= 1.4.2', require: false  # Reduces boot times through caching; required in config/boot.rb
gem 'devise', '~> 4.7', '>= 4.7.3'          # Flexible authentication solution for Rails with Warden
gem 'google_sign_in', '~> 1.2'              # Sign in (or up) with Google for Rails applications: https://github.com/basecamp/google_sign_in
gem 'image_processing', '~> 1.2'            # Use in Active Storage v 6.1.1
gem 'jbuilder', '~> 2.7'                    # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'mini_magick', '~> 4.10', '>= 4.10.1'   # Manipulate images with minimal use of memory via ImageMagick / GraphicsMagick
gem 'omniauth', '~> 1.9', '>= 1.9.1'        # Omniauth logins
gem 'omniauth-google-oauth2', '~> 0.8.1'    # Omniauth for google
gem 'pagy', '~> 3.5'                        # Agnostic pagination in plain ruby
gem 'pg', '>= 0.18', '< 2.0'                # Use postgresql as the database for Active Record
gem 'premailer-rails', '~> 1.11', '>= 1.11.1' # Styling HTML emails with CSS without having to do the hard work ourselves
gem 'puma', '~> 4.1'                        # Use Puma as the app server
gem 'rails', '~> 6.1', '>= 6.1.1'           # If you're not sure what this is for then you're in the wrong place ;)
gem 'sass-rails', '>= 6'                    # Use SCSS for stylesheets
gem 'table_print', '~> 1.5', '>= 1.5.7'     # Allows viewing of data in console in nice ways, including table joins: http://tableprintgem.com/ (video)
gem 'turbolinks', '~> 5'                    # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'webpacker', '~> 5.2', '>= 5.2.1'       # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'wicked', '~> 1.3', '>= 1.3.2'          # Wicked is a Rails engine for producing easy wizard controllers
gem 'sidekiq', '~> 6.1', '>= 6.1.3'         # Simple, efficient background processing for Ruby.

group :development, :staging, :admin do
  gem 'activeadmin', '~> 2.8', '>= 2.8.1'     # Administration DSL out of a box: https://activeadmin.info/
  gem 'activeadmin_addons'
end

group :production, :staging, :admin do
  gem 'aws-sdk-s3', '~> 1.83', '>= 1.83.1', require: false  # Amazon Simple Storage Service is a web service that provides highly scalable cloud storage
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]   # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'cypress-on-rails'                                # Gem for using cypress.io in Rails and ruby rack applications
  gem 'rubocop', '~> 0.90.0', require: false            # Needed to fix CodeClimate issues
  gem 'rspec-rails'                                     # rspec-rails is a testing framework for Rails 5+.
  gem 'letter_opener'                                   # Allows for seeing sent emails in dev environment
  gem 'letter_opener_web'                               # GUI for letter_opener
end

group :development, :test, :staging do
  gem 'faker', github: 'stympy/faker'                   # Easy way to add fake data: names, email addresses, etc.
  gem 'factory_bot_rails'                               # Fixtures but better
end

group :test do
  # Gems in this group do not require version numbers
  gem 'database_cleaner'                                # Cleans the database data between tests
  gem 'shoulda-matchers'                                # Collection of testing matchers extracted from Shoulda http://thoughtbot.com/community
  gem 'rails-controller-testing'                        # This gem brings back assigns to your controller tests as well as assert_template to both controller and integration tests.
end

group :development do
  # Gems in this group do not require version numbers
  gem 'git-smart'                           # Makes using git in terminal better: https://github.com/geelen/git-smart
  gem 'listen'                              # The Listen gem listens to file modifications and notifies you about the changes: https://github.com/guard/listen
  gem 'spring'                              # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'web-console'                         # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]    # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

# The gems below were recommended by the base Rails install
# gem 'redis', '~> 4.0'                   # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7'                # Use Active Model has_secure_password