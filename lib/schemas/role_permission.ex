defmodule SimpleRbac.RolePermissions.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "role_permissions" do
    belongs_to(:role, SimpleRbac.Roles.Role)
    belongs_to(:permission, SimpleRbac.Permissions.Permission)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [:role_id, :permission_id])
    |> validate_required([:role_id, :permission_id])
  end
end
