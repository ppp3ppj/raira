defmodule Raira.TestingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Raira.Testing` context.
  """

  @doc """
  Generate a suite.
  """
  def suite_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: "some name"
      })

    {:ok, suite} = Raira.Testing.create_suite(scope, attrs)
    suite
  end
end
