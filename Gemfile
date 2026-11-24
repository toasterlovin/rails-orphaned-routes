source "https://rubygems.org"

# Only the parts of Rails this app uses, all on one version. Dependabot
# updates them together (see .github/dependabot.yml).
rails_version = "~> 8.1.4"
gem "railties", rails_version
gem "actionpack", rails_version
gem "actionview", rails_version
gem "activerecord", rails_version
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"

group :development, :test do
  gem "bundler-audit", require: false
  gem "rspec-rails", "~> 8.0"
end
