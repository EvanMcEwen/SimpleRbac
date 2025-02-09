defmodule SimpleRbac.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

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
