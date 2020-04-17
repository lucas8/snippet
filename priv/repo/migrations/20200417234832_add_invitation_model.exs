defmodule Snippet.Repo.Migrations.AddInvitationModel do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :snippet_id, references(:code_snippets, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:invites, [:snippet_id])
    create index(:invites, [:user_id])
  end
end
