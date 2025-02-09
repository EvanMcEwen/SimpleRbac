defmodule Mix.Tasks.SimpleRbac.Setup do
  @moduledoc """
  Sets up SimpleRbac by creating necessary database migrations.

  Run this task to generate the required database tables for SimpleRbac:
  ```bash
  mix simple_rbac.setup
  ```

  This will create migrations for:
  - Permissions table
  - Roles table
  - Role-Permission associations table
  """

  use Mix.Task

  @shortdoc "Sets up SimpleRbac by creating necessary migrations"
  @migrations_path "priv/repo/migrations"

  def run(_args) do
    create_migrations()
  end

  defp create_migrations do
    Mix.shell().info("\nGenerating SimpleRbac migrations...")

    case create_migration("create_rbac_tables", create_rbac_tables_template()) do
      :ok ->
        Mix.shell().info([:green, "• Created RBAC tables migration"])

      {:error, reason} ->
        Mix.shell().error("""
        Failed to create RBAC tables migration!
        Error: #{inspect(reason)}
        """)

        exit({:shutdown, 1})
    end

    Mix.shell().info([:green, "\n✓ SimpleRbac migrations generated successfully!"])

    print_post_setup_instructions()
  end

  defp create_migration(name, content) do
    Mix.Tasks.Ecto.Gen.Migration.run([name])
    migration_file = find_latest_migration(name)
    File.write!(migration_file, content)
    :ok
  rescue
    error in [Mix.Error] ->
      if String.contains?(error.message, "there is already a migration file") do
        :ok
      else
        {:error, error.message}
      end
  end

  defp find_latest_migration(name) do
    @migrations_path
    |> File.ls!()
    |> Enum.filter(&String.contains?(&1, name))
    |> Enum.sort()
    |> List.last()
    |> then(&Path.join(@migrations_path, &1))
  end

  defp create_rbac_tables_template do
    """
    defmodule #{app_prefix()}.Repo.Migrations.CreateRbacTables do
      use Ecto.Migration

      def change do
        create table(:simple_rbac_permissions) do
          add :name, :string, null: false
          add :description, :string, null: false

          timestamps(type: :utc_datetime)
        end

        create unique_index(:simple_rbac_permissions, [:name])

        # Insert superadmin permission
        execute(
          "INSERT INTO simple_rbac_permissions (name, description, inserted_at, updated_at) VALUES ('*:*', 'Superadmin permission with full access to all resources', NOW(), NOW())",
          "DELETE FROM simple_rbac_permissions WHERE name = '*:*'"
        )

        create table(:simple_rbac_roles) do
          add :name, :string, null: false

          timestamps(type: :utc_datetime)
        end

        create unique_index(:simple_rbac_roles, [:name])

        create table(:simple_rbac_role_permissions) do
          add :role_id, references(:simple_rbac_roles, on_delete: :nothing)
          add :permission_id, references(:simple_rbac_permissions, on_delete: :nothing)

          timestamps(type: :utc_datetime)
        end

        create index(:simple_rbac_role_permissions, [:role_id])
        create index(:simple_rbac_role_permissions, [:permission_id])
      end
    end
    """
  end

  defp app_prefix do
    Mix.Project.config()[:app]
    |> to_string()
    |> Macro.camelize()
  end

  defp print_post_setup_instructions do
    Mix.shell().info("""

    🎉 SimpleRbac setup completed!

    Next steps:

    1. Configure your Repo in config/config.exs:

       config :simple_rbac,
         repo: YourApp.Repo

    2. Run the migrations:

       mix ecto.migrate

    3. Start using SimpleRbac in your controllers/live views:

       use SimpleRbac.PermissionsHelper

    For more information, check the documentation at:
    https://hexdocs.pm/simple_rbac
    """)
  end
end
