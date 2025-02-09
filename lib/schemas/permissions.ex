defmodule SimpleRbac.Permissions do
  @moduledoc """
  The Permissions context.
  """

  import Ecto.Query, warn: false

  # Remove compile-time repo configuration
  # Add runtime repo getter
  defp repo, do: Application.get_env(:simple_rbac, :repo, SimpleRbac.Repo)

  alias SimpleRbac.Permissions.Permission

  @doc """
  Returns the list of permissions.

  ## Examples

      iex> list_permissions()
      [%Permission{}, ...]

  """
  def list_permissions(user_id) do
    from(
      permission in Permission,
      join: role_permission in RolePermission,
      on: permission.id == role_permission.permission_id,
      join: role in Role,
      on: role_permission.role_id == role.id,
      join: user_role in UserRole,
      on: role.id == user_role.role_id,
      where: user_role.user_id == ^user_id,
      distinct: permission.id
    )
    |> repo().all()
  end

  def list_permissions do
    repo().all(Permission)
  end

  @doc """
  Gets a single permission.

  Raises `Ecto.NoResultsError` if the Permission does not exist.

  ## Examples

      iex> get_permission!(123)
      %Permission{}

      iex> get_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission!(id), do: repo().get!(Permission, id)

  @doc """
  Creates a permission.

  ## Examples

      iex> create_permission(%{field: value})
      {:ok, %Permission{}}

      iex> create_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> repo().insert()
  end

  @doc """
  Updates a permission.

  ## Examples

      iex> update_permission(permission, %{field: new_value})
      {:ok, %Permission{}}

      iex> update_permission(permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> repo().update()
  end

  @doc """
  Deletes a permission.

  ## Examples

      iex> delete_permission(permission)
      {:ok, %Permission{}}

      iex> delete_permission(permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission(%Permission{} = permission) do
    repo().delete(permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission changes.

  ## Examples

      iex> change_permission(permission)
      %Ecto.Changeset{data: %Permission{}}

  """
  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end
end
