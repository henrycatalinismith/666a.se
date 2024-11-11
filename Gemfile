source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", github: "rails/rails", branch: "main", ref: "3e2834604bbdfd6c14bea210d9f9adf2a9132902"
gem "sqlite3", ">= 2.1"

gem "solid_cache"
gem "solid_queue"
gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "tailwindcss-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 6.1.1"
  gem "rubocop"
  gem "rubocop-rails", "~> 2.24"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails", "~> 2.28"
  gem "timecop", "~> 0.9.8"
  gem "webmock"
end

gem "chartkick", "~> 5.0"
gem "devise", "~> 4.9"
gem "discordrb"
gem "dockerfile-rails", ">= 1.5", group: :development
gem "dotenv", groups: [:development, :test]
gem "dry-schema"
gem "flipper"
gem "flipper-active_record", "~> 1.3"
gem "flipper-ui", "~> 1.3"
gem "front_matter_parser"
gem "importmap-rails", "~> 1.2"
gem "lookbook"
gem "redcarpet", "~> 3.6"
gem "rufus-scheduler", "~> 3.9"
gem "sentry-rails", "~> 5.11"
gem "sentry-ruby", "~> 5.11"
gem "slack-ruby-client"
gem "sqlite-ulid", "~> 0.2.1"
gem "stimulus-rails"
gem "view_component"
gem "rails_admin"
gem "cssbundling-rails"
gem "sassc"
gem "cancancan"

gem "ruby-openai", "~> 7.1"
gem "foreman"
