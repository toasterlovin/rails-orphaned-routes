# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Security: Gem audit", "bin/bundler-audit"
  step "Tests: Rails", "bin/rails test"
  step "Tests: RSpec", "bin/rspec"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"
end
