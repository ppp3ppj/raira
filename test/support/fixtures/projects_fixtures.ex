defmodule Raira.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Raira.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: "some name",
        status: "some status"
      })

    {:ok, project} = Raira.Projects.create_project(scope, attrs)
    project
  end
end
