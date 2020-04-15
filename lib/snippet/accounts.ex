defmodule Snippet.Accounts do
  alias Snippet.Repo
  alias Snippet.Accounts.User

  def insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end

  def get_user!(id), do: Repo.get!(User, id)
end
