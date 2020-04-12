defmodule Snippet.Repo.Migrations.CreateCodeSnippets do
  use Ecto.Migration

  def change do
    create table(:code_snippets) do
      add :name, :string, size: 30
      add :author, :string, size: 30
      add :slug, :string
      add :body, :text, null: true

      timestamps()
    end

    create unique_index(:code_snippets, [:slug])
  end
end
