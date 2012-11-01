source 'https://rubygems.org'

gem 'rails', '3.2.1'

gem 'jquery-rails'

gem "mongoid", "~> 2.4"
gem "bson_ext", "~> 1.5"

gem 'mail_form'
gem 'devise'
gem 'devise_invitable'
gem 'event-calendar', :require => 'event_calendar'
#gem "watu_table_builder", :require => "table_builder"

#Facebook login
gem 'omniauth'
gem 'omniauth-facebook'
gem 'oauth2'

gem 'fancybox-rails', :git => 'git://github.com/sverigemeny/fancybox-rails.git'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  
  gem 'zurb-foundation', '~> 3.2'
  gem 'uglifier', '>= 1.0.3'
  gem "haml-rails"
end

group :development, :test do
	gem "rspec-rails"
  gem 'guard'
  gem 'guard-cucumber'
  gem 'ruby_gntp'
end

group :test do
	gem "factory_girl_rails", ">= 1.6.0"
  gem "cucumber-rails", ">= 1.2.1"
  gem "capybara", ">= 1.1.2"
  gem "database_cleaner"
  gem 'mongoid-rspec'
  gem 'guard-rspec'
	gem 'email_spec'
end

group :production do
	gem 'heroku'
	gem 'pg'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
gem "unicorn-rails"

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
