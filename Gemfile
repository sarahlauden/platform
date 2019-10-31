source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'
gem 'rails', '~> 6.0.0'

gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'dotenv'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'guard-rails', require: false
  gem 'guard-rspec', require: false
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'guard-webpacker'
  gem 'webpacker-react', "~> 1.0.0.beta.1"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  # Report test coverage
  gem 'codacy-coverage'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'paranoia'
gem 'will_paginate'
gem 'bulk_insert'

gem 'devise'
gem 'devise_cas_authenticatable'

gem 'react-rails'

gem 'sentry-raven'

# Using a branch for a time being to remove R18n until we decide what we want to do
gem 'rubycas-server-core', github: 'bebraven/rubycas-server-core', branch: 'platform-compat'
gem 'rubycas-server-activerecord'
