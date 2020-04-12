defmodule Snippet.Content do
  alias Snippet.Repo
  alias Snippet.Content.CodeSnippet

  def create_snippet(params) do
    CodeSnippet.changeset(%CodeSnippet{}, params) |> Repo.insert()
  end
end
