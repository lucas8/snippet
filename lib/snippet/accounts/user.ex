defmodule Snippet.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :username, :string
    field :profile_url, :string

    has_many :code_snippets, Snippet.Content.CodeSnippet
    has_many :invites, Snippet.Content.Invite

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:token, :email, :provider, :username, :profile_url])
    |> validate_required([:token, :email, :provider, :username])
    |> unique_constraint(:email)
  end
end
