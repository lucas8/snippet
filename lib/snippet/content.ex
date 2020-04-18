defmodule Snippet.Content do
  alias Snippet.Repo
  alias Snippet.Content.CodeSnippet

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


  def create_invite(snippet, user) do
    snippet
    |> Ecto.build_assoc(:invites, user_id: user.id)
    |> Repo.insert()
  end
end
