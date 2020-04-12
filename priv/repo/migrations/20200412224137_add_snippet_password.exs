defmodule Snippet.Repo.Migrations.AddSnippetPassword do
  use Ecto.Migration

  def change do
    alter table(:code_snippets) do
      add :password, :string, null: true
    end
  end
end
