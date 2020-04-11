defmodule Snippet.Repo.Migrations.CreateCodeSnippets do
  use Ecto.Migration

  def change do
    create table(:code_snippets) do
      add :name, :string
      add :author, :string
      add :slug, :string
      add :body, :string

      timestamps()
    end

    create unique_index(:code_snippets, [:slug])
  end
end
