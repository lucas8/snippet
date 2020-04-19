defmodule Snippet.Accounts do
  alias Snippet.Repo
  alias Snippet.Accounts.User

  import Ecto.Query

  def insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_username!(username), do: Repo.get_by!(User, username: username)

  def sign_out(conn) do
    Plug.Conn.configure_session(conn, drop: true)
  end

  def find_like_user(user_fragment, limit \\ 5) do
    Repo.all(
      from usr in User,
      select: %{
        username: usr.username,
        profile_url: usr.profile_url
      },
      where: ilike(usr.username, ^"%#{user_fragment}%"),
      limit: ^limit
    )
  end
end
