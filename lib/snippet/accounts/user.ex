defmodule Snippet.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :provider, :string
    field :token, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:token, :name, :email, :provider, :username])
    |> validate_required([:token, :name, :email, :provider, :username])
    |> unique_constraint(:email)
  end
end
