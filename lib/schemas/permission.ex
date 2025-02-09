defmodule SimpleRbac.Permissions.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for storing permissions in the database.

  A permission represents a specific action that can be performed in the system.
  Permissions are assigned to roles, which are then assigned to users.

  ## Fields

    * name - The unique identifier for the permission (e.g., "admin:read")
    * description - A human-readable description of what the permission allows
  """

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
