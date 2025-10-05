defmodule Raira.Config do
  @app_version Mix.Project.config()[:version]

  @doc """
  Returns the current version of running Livebook.
  """
  def app_version(), do: @app_version
end
