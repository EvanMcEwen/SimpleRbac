defmodule SimpleRbac.PermissionsHelper do
  @moduledoc """
  Provides permission checking functionality through a macro.
  """

  defmacro __using__(_opts) do
    quote do
      import SimpleRbac.PermissionsHelper, only: [has_permission?: 2]
    end
  end

  @doc """
  Checks if a user has a specific permission.

  ## Parameters
    - current_user: The user struct containing permission_list
    - permission: String representing the permission to check

  ## Examples
      iex> has_permission?(current_user, "admin.users.read")
      true
  """
  def has_permission?(%{permission_list: permissions}, permission) when is_list(permissions) do
    permission in permissions ||
      star_scope(permission) in permissions ||
      all_scope() in permissions
  end

  def has_permission?(_user, _permission), do: false

  defp model_scope(permission), do: String.split(permission, ":") |> List.last()
  defp star_scope(permission), do: "*:#{model_scope(permission)}"
  defp all_scope, do: "*:*"
end
