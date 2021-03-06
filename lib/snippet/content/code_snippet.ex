defmodule Snippet.Content.CodeSnippet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "code_snippets" do
    field :author, :string
    field :body, :string
    field :name, :string
    field :slug, :string
    field :public, :boolean

    belongs_to :user, Snippet.Accounts.User
    has_many :invites, Snippet.Content.Invite

    timestamps()
  end

  @doc false
  def changeset(code_snippet, attrs) do
    code_snippet
    |> cast(attrs, [:name, :author, :slug, :body, :public])
    |> validate_required([:name, :author, :slug])
    |> unique_constraint(:slug)
    |> validate_length(:name, max: 30)
    |> validate_length(:author, max: 30)
  end
end
