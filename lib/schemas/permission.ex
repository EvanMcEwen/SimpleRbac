defmodule SimpleRbac.Permissions.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "simple_rbac_permissions" do
    field(:name, :string)
    field(:description, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
