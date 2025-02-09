defmodule SimpleRbac do
  @moduledoc """
  SimpleRbac is a straightforward role-based access control (RBAC) library for Phoenix applications.

  ## Installation

  1. Add simple_rbac to your dependencies in mix.exs:

      ```elixir
      def deps do
        [
          {:simple_rbac, "~> 0.1.0"}
        ]
      end
      ```

  2. Configure your Repo in config/config.exs:

      ```elixir
      config :simple_rbac,
        repo: YourApp.Repo
      ```

  3. Generate and run the migrations:

      ```bash
      mix simple_rbac.setup
      mix ecto.migrate
      ```

  ## Usage

  Permissions can be created using the create_permission/3 function:

      ```elixir
      alias SimpleRbac.Permissions

      # Create a new permission
      {:ok, permission} = Permissions.create_permission("read", "admin", "Can access admin section")
      ```

  Add the permission checker to your controllers or LiveView modules:

      ```elixir
      defmodule YourAppWeb.AdminController do
        use SimpleRbac.PermissionsHelper

        def index(conn, _params) do
          if has_permission?(conn.assigns.current_user, "read:admin") do
            # Protected content
          else
            # Handle unauthorized access
          end
        end
      end
      ```

  ## Permission Format

  Permissions are defined in the format `"action:scope"`, where:
  - `action` is the operation being performed (e.g., "read", "write", "delete")
  - `scope` is the resource or area being accessed (e.g., "posts", "users", "admin")

  Examples:
  - `"read:posts"`
  - `"write:comments"`
  - `"delete:users"`
  - `"*:admin"` (all actions in admin scope)
  - `"*:*"` (superuser access)
  """
end
