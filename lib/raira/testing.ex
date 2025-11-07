defmodule Raira.Testing do
  @moduledoc """
  The Testing context.
  """

  import Ecto.Query, warn: false
  alias Raira.Repo

  alias Raira.Testing.Suite
  alias Raira.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any suite changes.

  The broadcasted messages match the pattern:

    * {:created, %Suite{}}
    * {:updated, %Suite{}}
    * {:deleted, %Suite{}}

  """
  def subscribe_suites(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Raira.PubSub, "user:#{key}:suites")
  end

  defp broadcast_suite(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Raira.PubSub, "user:#{key}:suites", message)
  end

  @doc """
  Returns the list of suites.

  ## Examples

      iex> list_suites(scope)
      [%Suite{}, ...]

  """
  def list_suites(%Scope{} = scope) do
    Repo.all_by(Suite, user_id: scope.user.id)
  end

  @doc """
  Gets a single suite.

  Raises `Ecto.NoResultsError` if the Suite does not exist.

  ## Examples

      iex> get_suite!(scope, 123)
      %Suite{}

      iex> get_suite!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_suite!(%Scope{} = scope, id) do
    Repo.get_by!(Suite, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a suite.

  ## Examples

      iex> create_suite(scope, %{field: value})
      {:ok, %Suite{}}

      iex> create_suite(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_suite(%Scope{} = scope, attrs) do
    with {:ok, suite = %Suite{}} <-
           %Suite{}
           |> Suite.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_suite(scope, {:created, suite})
      {:ok, suite}
    end
  end

  @doc """
  Updates a suite.

  ## Examples

      iex> update_suite(scope, suite, %{field: new_value})
      {:ok, %Suite{}}

      iex> update_suite(scope, suite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_suite(%Scope{} = scope, %Suite{} = suite, attrs) do
    true = suite.user_id == scope.user.id

    with {:ok, suite = %Suite{}} <-
           suite
           |> Suite.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_suite(scope, {:updated, suite})
      {:ok, suite}
    end
  end

  @doc """
  Deletes a suite.

  ## Examples

      iex> delete_suite(scope, suite)
      {:ok, %Suite{}}

      iex> delete_suite(scope, suite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_suite(%Scope{} = scope, %Suite{} = suite) do
    true = suite.user_id == scope.user.id

    with {:ok, suite = %Suite{}} <-
           Repo.delete(suite) do
      broadcast_suite(scope, {:deleted, suite})
      {:ok, suite}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking suite changes.

  ## Examples

      iex> change_suite(scope, suite)
      %Ecto.Changeset{data: %Suite{}}

  """
  def change_suite(%Scope{} = scope, %Suite{} = suite, attrs \\ %{}) do
    true = suite.user_id == scope.user.id

    Suite.changeset(suite, attrs, scope)
  end
end
