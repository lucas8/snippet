defmodule Snippet.Repo.Migrations.AssocUserWithSnippet do
  use Ecto.Migration

  def change do
    alter table(:code_snippets) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
