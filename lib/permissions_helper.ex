defmodule SimpleRbac.PermissionsHelper do
  @moduledoc """
  Provides permission checking functionality through macros and helper functions.

  This module implements the core permission checking logic, supporting:
  - Exact permission matching
  - Wildcard permissions using "*"
  - Action-scope based permissions

  ## Permission Format

  Permissions follow the format: `"action:scope"`

  Examples:
  - `"read:users"`
  - `"write:posts"`
  - `"delete:comments"`
  - `"*:posts"` (wildcard for any action on posts)
  - `"*:*"` (superuser access)
  """

  defmacro __using__(_opts) do
    quote do
      import SimpleRbac.PermissionsHelper, only: [has_permission?: 2]
    end
  end

  @doc """
  Checks if a user has a specific permission.

  Supports exact matches and wildcard permissions using "*".

  ## Parameters
    - current_user: The user struct containing permission_list
    - permission: String representing the permission to check in format "action:scope"

  ## Examples
      iex> user = %{permission_list: ["read:admin", "*:posts"]}
      iex> has_permission?(user, "read:admin")
      true
      iex> has_permission?(user, "write:posts")
      true
      iex> has_permission?(user, "delete:users")
      false
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
