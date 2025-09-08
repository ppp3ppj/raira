defmodule Raira.Repo do
  use Ecto.Repo,
    otp_app: :raira,
    adapter: Ecto.Adapters.SQLite3
end
