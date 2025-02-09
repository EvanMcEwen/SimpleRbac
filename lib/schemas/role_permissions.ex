defmodule SimpleRbac.RolePermissions do
  @moduledoc """
  The RolePermissions context.
  """

  import Ecto.Query, warn: false

  # Add runtime repo getter
  defp repo, do: Application.get_env(:simple_rbac, :repo, SimpleRbac.Repo)

  alias SimpleRbac.RolePermissions.RolePermission

  @doc """
  Returns the list of role_permissions.

  ## Examples

      iex> list_role_permissions()
      [%RolePermission{}, ...]

  """
  def list_role_permissions do
    repo().all(RolePermission)
  end

  @doc """
  Gets a single role_permission.

  Raises `Ecto.NoResultsError` if the Role permission does not exist.

  ## Examples

      iex> get_role_permission!(123)
      %RolePermission{}

      iex> get_role_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role_permission!(id), do: repo().get!(RolePermission, id)

  @doc """
  Creates a role_permission.

  ## Examples

      iex> create_role_permission(%{field: value})
      {:ok, %RolePermission{}}

      iex> create_role_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role_permission(attrs \\ %{}) do
    %RolePermission{}
    |> RolePermission.changeset(attrs)
    |> repo().insert()
  end

  @doc """
  Updates a role_permission.

  ## Examples

      iex> update_role_permission(role_permission, %{field: new_value})
      {:ok, %RolePermission{}}

      iex> update_role_permission(role_permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role_permission(%RolePermission{} = role_permission, attrs) do
    role_permission
    |> RolePermission.changeset(attrs)
    |> repo().update()
  end

  @doc """
  Deletes a role_permission.

  ## Examples

      iex> delete_role_permission(role_permission)
      {:ok, %RolePermission{}}

      iex> delete_role_permission(role_permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role_permission(%RolePermission{} = role_permission) do
    repo().delete(role_permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role_permission changes.

  ## Examples

      iex> change_role_permission(role_permission)
      %Ecto.Changeset{data: %RolePermission{}}

  """
  def change_role_permission(%RolePermission{} = role_permission, attrs \\ %{}) do
    RolePermission.changeset(role_permission, attrs)
  end
end
