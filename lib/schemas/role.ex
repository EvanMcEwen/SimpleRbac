defmodule SimpleRbac.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for storing roles in the database.

  A role is a collection of permissions that can be assigned to users. This allows for
  grouping common permissions together and managing user access through role assignments.

  ## Fields

    * name - The unique identifier for the role (e.g., "admin", "editor", "viewer")
    * permissions - Associated permissions through the role_permissions join table
  """

  schema "simple_rbac_roles" do
    field(:name, :string)

    has_many(:role_permissions, SimpleRbac.RolePermissions.RolePermission)
    has_many(:permissions, through: [:role_permissions, :permission])

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
