defmodule SimpleRbac.Permissions.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for storing permissions in the database.

  A permission represents a specific action that can be performed in the system.
  Permissions are assigned to roles, which are then assigned to users.

  ## Fields

    * name - The permission in "action:scope" format (e.g., "read:admin")
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
    |> validate_single_colon()
    |> validate_permission_format()
  end

  defp validate_single_colon(changeset) do
    validate_change(changeset, :name, fn :name, value ->
      case value |> String.graphemes() |> Enum.count(&(&1 == ":")) do
        1 -> []
        0 -> [name: "must contain exactly one ':' character"]
        _ -> [name: "must contain exactly one ':' character"]
      end
    end)
  end

  defp validate_permission_format(changeset) do
    validate_change(changeset, :name, fn :name, value ->
      case String.split(value, ":") do
        [action, scope] when action != "" and scope != "" ->
          []

        _ ->
          [name: "must be in format 'action:scope' with non-empty values"]
      end
    end)
  end
end
