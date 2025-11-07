defmodule Raira.Testing.Suite do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "suites" do
    field :name, :string
    field :description, :string
    field :user_id, :binary_id

    belongs_to :project, Raira.Projects.Project

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(suite, attrs, user_scope) do
    suite
    |> cast(attrs, [:name, :description, :project_id])
    |> validate_required([:name, :project_id])
    |> validate_length(:name, min: 3, max: 100)
    |> put_change(:user_id, user_scope.user.id)
    |> unique_constraint([:name, :project_id],
      name: :suites_name_project_id_index,
      message: "Suite name must be unique per project"
    )
  end
end
