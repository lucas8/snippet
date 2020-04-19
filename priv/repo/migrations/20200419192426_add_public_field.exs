defmodule Snippet.Repo.Migrations.AddPublicField do
  use Ecto.Migration

  def change do
    alter table(:code_snippets) do
      add :public, :boolean, default: true
    end
  end
end
