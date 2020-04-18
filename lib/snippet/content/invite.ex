defmodule Snippet.Content.Invite do
  use Ecto.Schema

  schema "invites" do
    belongs_to :user, Snippet.Accounts.User
    belongs_to :code_snippet, Snippet.Content.CodeSnippet

    timestamps()
  end
end
