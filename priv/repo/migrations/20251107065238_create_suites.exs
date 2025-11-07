defmodule Raira.Repo.Migrations.CreateSuites do
  use Ecto.Migration

  def change do
    create table(:suites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :project_id, references(:projects, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:suites, [:user_id])

    create index(:suites, [:project_id])
    create unique_index(:suites, [:name, :project_id], name: :suites_name_project_id_index)
  end
end
