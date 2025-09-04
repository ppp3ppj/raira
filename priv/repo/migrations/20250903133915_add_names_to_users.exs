defmodule Raira.Repo.Migrations.AddNamesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # set null: false later if require first_name and last name not null
      add :first_name, :string, null: false
      add :last_name, :string, null: false
    end
  end
end
