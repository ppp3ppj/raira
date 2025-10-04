defmodule Raira.Utils do
  require Logger

  @type id :: String.t()

  @doc """
  Generates a random binary id.
  """
  @spec random_id() :: id()
  def random_id() do
    :crypto.strong_rand_bytes(10) |> Base.encode32(case: :lower)
  end

  @doc """
  Generates a random long binary id.
  """
  @spec random_long_id() :: id()
  def random_long_id() do
    :crypto.strong_rand_bytes(20) |> Base.encode32(case: :lower)
  end

  @doc """
  Generates a random short binary id.
  """
  @spec random_short_id() :: id()
  def random_short_id() do
    :crypto.strong_rand_bytes(5) |> Base.encode32(case: :lower)
  end
end
