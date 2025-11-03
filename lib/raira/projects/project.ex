defmodule Raira.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects" do
    field :name, :string
    field :description, :string
    #field :status, :string
    field :status, Ecto.Enum, values: [:active, :archived, :completed], default: :active
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs, user_scope) do
    project
    |> cast(attrs, [:name, :description, :status])
    |> validate_required([:name, :description, :status])
    |> put_change(:user_id, user_scope.user.id)
  end
end
