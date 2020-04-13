defmodule Snippet.Content do
  alias Snippet.Repo
  alias Snippet.Content.CodeSnippet

  def create_snippet(params) do
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

  @spec get_snippet_by_slug(any) :: any
  def get_snippet_by_slug(slug), do: Repo.get_by(CodeSnippet, slug: slug)
end
