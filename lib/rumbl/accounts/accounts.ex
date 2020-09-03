defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts Context
  """
  import Ecto.Query, warn: false
  alias Rumbl.Accounts.User
  alias Rumbl.Repo
  # alias Rumbl.Accounts

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """

  # def list_user_videos(%Accounts.User{} = user) do
  #     User
  #     |> user_videos_query(user)
  #     |> Repo.all()
  #   end
  #
  # defp user_videos_query(query, %Accounts.User{id: user_id}) do
  #   from(v in query, where: v.id == ^user_id)
  # end
  #

  def list_users do
    Repo.all(User)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
