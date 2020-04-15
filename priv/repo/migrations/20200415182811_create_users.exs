defmodule Snippet.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :token, :string, null: false
      add :name, :string
      add :email, :string, null: false
      add :provider, :string, null: false
      add :username, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
