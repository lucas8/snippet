defmodule Snippet.Content do
  alias Snippet.Repo
  alias Snippet.Content.CodeSnippet
  alias Snippet.Content.Invite

  import Ecto.Query

  def create_snippet(user, params \\ %{}) do
    user
    |> Ecto.build_assoc(:code_snippets)
    |> CodeSnippet.changeset(params)
    |> Repo.insert()
  end

  def create_snippet_no_user(params \\ %{}) do
    CodeSnippet.changeset(%CodeSnippet{}, params) |> Repo.insert()
  end

  def update_snippet(%CodeSnippet{} = snippet, attrs) do
    snippet
    |> CodeSnippet.changeset(attrs)
    |> Repo.update()
  end

  def delete_snippet(%CodeSnippet{} = snippet) do
    snippet |> Repo.delete()
  end

  def get_snippet_by_slug(slug), do: Repo.get_by(CodeSnippet, slug: slug)

  def create_invite(snippet, user, status) do
    snippet
    |> Ecto.build_assoc(:invites, user_id: user.id)
    |> Invite.changeset(%{status: status})
    |> Repo.insert()
  end

  def get_invites(snippet_id) do
    Repo.all(
      from inv in Invite,
        join: user in assoc(inv, :user),
        where: inv.code_snippet_id == ^snippet_id,
        order_by: [desc: inv.inserted_at],
        select: %{id: inv.id, status: inv.status, user: %{username: user.username, id: user.id}}
    )
  end

  def get_invite!(id), do: Repo.get!(Invite, id)
  
  def remove_invite(%Invite{} = invite), do: invite |> Repo.delete()
end
