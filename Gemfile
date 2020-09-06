source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'amazing_print', '~> 1.2', '>= 1.2.1' # Replacement for awesome_print which is depreciated
gem 'bootsnap', '>= 1.4.2', require: false  # Reduces boot times through caching; required in config/boot.rb
gem 'jbuilder', '~> 2.7'                  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'pg', '>= 0.18', '< 2.0'              # Use postgresql as the database for Active Record
gem 'puma', '~> 4.1'                      # Use Puma as the app server
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'     # If you're not sure what this is for then you're in the wrong place ;)
gem 'sass-rails', '>= 6'                  # Use SCSS for stylesheets
gem 'table_print', '~> 1.5', '>= 1.5.7'   # Allows viewing of data in console in nice ways, including table joins: http://tableprintgem.com/ (video)
gem 'turbolinks', '~> 5'                  # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'webpacker', '~> 4.0'                 # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker


# The gems below were recommended by the base Rails install
# gem 'redis', '~> 4.0'                   # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7'                # Use Active Model has_secure_password
# gem 'image_processing', '~> 1.2'        # Use Active Storage variant



group :development, :test do
  # Gems in this group do not require version numbers

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]   # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'faker'                                           # Easy way to add fake data: names, email addresses, etc.
  gem 'git-smart'                                       # Makes using git in terminal better: https://github.com/geelen/git-smart
  gem 'letter_opener'                                   # Allows for seeing sent emails in dev environment
  gem 'letter_opener_web'                               # GUI for letter_opener
end

group :development do
  # Gems in this group do not require version numbers

  gem 'web-console', '>= 3.3.0'             # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'spring'                              # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]    # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
