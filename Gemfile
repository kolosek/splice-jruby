source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'


platforms :jruby do
  # JDBC database adapters for database. Include relevant driver
  gem 'activerecord-jdbcderby-adapter'
  gem 'activerecord-jdbcsqlite3-adapter', platform: :jruby
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jdbc-mysql'
  gem 'activerecord-jdbc-adapter'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

platforms :ruby do
  gem 'mysql2'
  # Use postgresql as the database for Active Record
# gem 'pg'
end

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem "twitter-bootstrap-rails"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'draper'

gem 'rails_12factor'

# Load Jar dependencies
gem 'lock_jar'

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'byebug', platform: :mri

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring-jruby'
  gem 'spring'

end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'capybara-webkit'
  # Rspec command for spring
  gem 'spring-commands-rspec', '~> 1.0.4'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'
  gem 'better_errors'
  # gem 'binding_of_caller', platform: :jruby
end
