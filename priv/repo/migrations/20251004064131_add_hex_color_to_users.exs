defmodule Raira.Repo.Migrations.AddHexColorToUsers do
  use Ecto.Migration

  def change do
    alter table (:users) do
      add :hex_color, :string
    end
  end
end
