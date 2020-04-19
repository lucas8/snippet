defmodule Snippet.Content.Invite do
  use Ecto.Schema

  import Ecto.Changeset

  schema "invites" do
    field :status, :string

    belongs_to :user, Snippet.Accounts.User
    belongs_to :code_snippet, Snippet.Content.CodeSnippet

    timestamps()
  end

  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:status])
  end
end
