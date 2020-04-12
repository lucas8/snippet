defmodule Snippet.Content do
  alias Snippet.Repo
  alias Snippet.Content.CodeSnippet

  def create_snippet(params) do
    CodeSnippet.changeset(%CodeSnippet{}, params) |> Repo.insert()
  end

  def get_snippet_by_slug(slug), do: Repo.get_by(CodeSnippet, slug: slug)
end
