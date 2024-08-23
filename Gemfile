# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.3'

gem 'activemodel'

gem 'rails', '~> 7.1.3', '>= 7.1.3.4'

gem 'puma', '>= 5.0'

gem 'jbuilder', '~> 2.12'
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'bootsnap', require: false

gem 'rack-cors', '~> 2.0.2'

gem 'redis', '~> 5.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'factory_bot_rails', '~> 6.4'
  gem 'ffaker', '~> 2.23'
  gem 'rspec-rails', '~> 6.1'
end

group :development do
end
