defmodule Raira.Accounts.Approvals do
  alias Raira.{Repo}
  alias Raira.Accounts.User
  alias Ecto.Multi

  def approve(%User{status: :pending, is_banned: false} = u) do
    update(u, %{status: :confirmed, reject_reason: nil, rejected_at: nil})
  end

  def pending(%User{status: :confirmed, is_banned: false} = u) do
    update(u, %{status: :pending, reject_reason: nil, rejected_at: nil})
  end

  # Fix me add and byte_size(String.trim(reason)) > 0 guard for check reason string not empty
  def reject(%User{status: :pending, is_banned: false} = u, reason, cooldown_days \\ 7)
      when is_binary(reason) do
    now = DateTime.utc_now()

    update(u, %{
      status: :rejected,
      reject_reason: reason,
      rejected_at: now,
      reapply_after: DateTime.add(now, cooldown_days * 86_400, :second),
      attempt_count: (u.attempt_count || 0) + 1
    })
  end

  def reopen(%User{status: :rejected, is_banned: false} = u) do
    if u.reapply_after && DateTime.compare(DateTime.utc_now(), u.reapply_after) == :lt do
      {:error, :cooldown}
    else
      update(u, %{status: :pending, reject_reason: nil, rejected_at: nil})
    end
  end

  def ban(u), do: update(u, %{is_banned: true})
  def unband(u), do: update(u, %{is_banned: false})

  defp update(%User{} = u, attrs) do
    IO.inspect(attrs, label: "Updating user with")
    Multi.new()
    |> Multi.update(:user, User.changeset(u, attrs))
    |> Repo.transaction()
    |> then(fn
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, cs, _} -> {:error, cs}
    end)
  end
end
