require "test_helper"

class OrphanedRoutesTest < ActionDispatch::IntegrationTest
  # By default, Rails rescues exceptions raised during integration tests and
  # renders an error page instead (`config.action_dispatch.show_exceptions` is
  # `:rescuable` in the test environment). We need those exceptions to bubble
  # up so we can tell what kind of error each route produces.
  setup do
    @show_exceptions = Rails.application.env_config["action_dispatch.show_exceptions"]
    Rails.application.env_config["action_dispatch.show_exceptions"] = :none
  end

  teardown do
    Rails.application.env_config["action_dispatch.show_exceptions"] = @show_exceptions
  end

  def defined_routes
    Rails.application.routes.routes.filter_map do |route|
      # Skip mounted Rack apps, which don't have a verb
      next if route.verb.blank?

      # Turn the route path spec into a string:
      # - Remove the "(.:format)" bit at the end
      # - Use "1" for all params
      path = route.path.spec.to_s.gsub(/\(\.:format\)/, "").gsub(/:[a-zA-Z_]+/, "1")
      # Route verbs are stored as strings like "GET"; convert them to symbols
      verb = route.verb.downcase.to_sym
      # Return a hash with two keys: the route path and its verb
      { path: path, verb: verb }
    end
  end

  test "no orphaned routes exist" do
    orphaned_routes = []

    # Ignore the routes Rails defines for itself (Active Storage, Action Mailbox, etc.)
    defined_routes.reject { |route| route[:path].start_with?("/rails/") }.each do |route|
      begin
        reset!
        # Use the route's verb to access the route's path, following any redirects
        process(route[:verb], route[:path])
        follow_redirect! while response.redirect?
      rescue ActionDispatch::MissingController, AbstractController::ActionNotFound
        # ActionDispatch::MissingController means the controller doesn't exist
        # AbstractController::ActionNotFound means the action doesn't exist
        orphaned_routes << "#{route[:verb]} #{route[:path]}"
      rescue ActiveRecord::RecordNotFound, ActionController::ParameterMissing
        # ActiveRecord::RecordNotFound happens because we are using 1 for all the route params
        # ActionController::ParameterMissing happens because we aren't submitting params to create or update
      end
    end

    # Fail if we have any orphaned routes
    assert orphaned_routes.empty?,
      "The following routes lead to nowhere: \n\t#{orphaned_routes.uniq.join("\n\t")}"
  end
end
