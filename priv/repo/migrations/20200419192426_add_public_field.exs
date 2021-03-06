defmodule Snippet.Repo.Migrations.AddPublicField do
  use Ecto.Migration

  def change do
    alter table(:code_snippets) do
      add :public, :boolean, default: false
    end
  end
end
