source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2.6'
gem 'sqlite3'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'


gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'rspec-rails'
  gem "factory_bot_rails"
  gem 'faker'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'

# gem "refile", require: "refile/rails", github: 'manfe/refile'
# gem "refile-mini_magick"
gem 'imgix-rails'
gem 'carrierwave', '~> 2.0'
gem 'fog-aws'

gem 'pry-byebug'

gem 'bootstrap', '~> 4.5'
gem 'jquery-rails'
gem 'jp_prefecture'
gem 'font-awesome-sass', '~> 5.13'
gem 'kaminari', '~> 0.17.0'
gem 'enum_help'

gem 'dotenv-rails'
group :production do
  gem 'mysql2'
end

gem 'aws-sdk'