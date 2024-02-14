# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby_version = File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip
ruby ruby_version

gem 'activerecord-import'
gem 'auto_strip_attributes'
gem 'bootsnap', require: false
gem 'bootstrap-sass', "~> 3.4.1"
gem 'cleantalk'
gem 'coffee-rails'
gem 'devise'
gem 'factory_bot_rails'
gem 'faker'
gem 'faraday'
gem 'faraday_middleware'
gem 'feedbag'
gem 'feedjira', "~> 3.0"
gem 'font-awesome-rails'
gem 'good_job', "~> 3.0"
gem 'jquery-rails'
gem 'kramdown'
gem 'mandrill-rails', '~> 1.5'
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'pg'
gem 'pry-rails'
gem 'puma'
gem 'rack-host-redirect'
gem 'rails', "~> 6.1.0"
gem 'sass-rails'
gem 'sentry-raven'
gem 'slim-rails'
gem 'uglifier'

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'cuprite'
  gem 'fuubar'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'webmock'
end

group :development, :test do
  gem 'axe-matchers'
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'letter_opener'
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'slim_lint', require: false
  gem 'web-console'
end
