# Orphaned Routes

An example app showing how to write a test that finds routes which lead nowhere:
routes whose controller or action doesn't exist.

The test lives in two flavors:

* Minitest: `test/integration/orphaned_routes_test.rb`
* RSpec: `spec/requests/orphaned_routes_spec.rb`

Both walk every route in `Rails.application.routes`, request it, and flag any that
raise `ActionDispatch::MissingController` (no controller) or
`AbstractController::ActionNotFound` (no action).

## Trying it out

```sh
bin/setup --skip-server
bin/rails test
bin/rspec
```

Everything passes out of the box. To see the test catch orphaned routes, uncomment
the `doodads` and `widgets` routes in `config/routes.rb`, or remove the `edit`
action from `ThingsController`.

## Requirements

* Ruby 3.4
* Rails 8.1
* SQLite 3
