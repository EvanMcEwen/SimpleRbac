# SimpleRbac

A straightforward role-based access control (RBAC) library for Phoenix applications. SimpleRbac provides an easy way to manage permissions and roles in your Phoenix application through a simple "action:scope" permission format.

## Features

- Simple permission format (`action:scope`)
- Wildcard permission support (`*:posts`, `*:*`)
- Role-based permission grouping
- Database-backed roles and permissions
- Easy integration with Phoenix controllers and LiveView

## Installation

1. Add `simple_rbac` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_rbac, "~> 0.1.0"}
  ]
end
```

2. Configure your Repo in `config/config.exs`:

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

### Basic Permission Checking

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

I'm currently assuming that you have inside of your `current_user` map a list called `permissions_list` that is simply a list of all the permissions the user has been granted.
Currently working on documentation and code to help facilitate this.

### Permission Format

Permissions are defined in the format `"action:scope"`, where:
- `action` is the operation being performed (e.g., "read", "write", "delete")
- `scope` is the resource or area being accessed (e.g., "posts", "users", "admin")

Examples:
- `"read:posts"` - Permission to read posts
- `"write:comments"` - Permission to create/update comments
- `"delete:users"` - Permission to delete users
- `"*:admin"` - All actions in admin scope
- `"*:*"` - Superuser access (all actions in all scopes)

### Managing Roles and Permissions

SimpleRbac provides contexts for managing roles and permissions:

```elixir
alias SimpleRbac.Roles
alias SimpleRbac.Permissions

# Create a new role
{:ok, admin_role} = Roles.create_role(%{name: "admin"})

# Create permissions
{:ok, read_posts} = Permissions.create_permission(%{
  name: "read:posts",
  description: "Can read blog posts"
})

# Associate permissions with roles through role_permissions
{:ok, _} = SimpleRbac.RolePermissions.create_role_permission(%{
  role_id: admin_role.id,
  permission_id: read_posts.id
})
```

## Schema Structure

SimpleRbac creates the following database tables:
- `simple_rbac_permissions` - Stores individual permissions
- `simple_rbac_roles` - Stores role definitions
- `simple_rbac_role_permissions` - Join table for role-permission associations

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

