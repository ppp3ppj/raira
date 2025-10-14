defmodule Raira.Repo.Migrations.AddUserTriState do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :status, :string, null: false, default: "pending"
      add :is_banned, :boolean, null: false, default: false
      add :reject_reason, :text
      add :rejected_at, :utc_datetime_usec
      add :reapply_after, :utc_datetime_usec
      add :attempt_count, :integer, null: false, default: 0
    end

    create index(:users, [:status])
    create index(:users, [:is_banned])
  end
end
