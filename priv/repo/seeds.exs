# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Raira.Repo.insert!(%Raira.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Raira.Repo
alias Raira.Accounts

admin_flname = "admin"
admin_email = "admin@admin.com"
password = "supersecret123"
admin_name = "admin"

user_flname = "user"
user_email = "user@user.com"
user_name = "user"


case Accounts.get_user_by_email(admin_email) do
  nil ->
    {:ok, _admin} = Accounts.register_user(%{
      first_name: admin_flname,
      last_name: admin_flname,
      username: admin_name,
      email: admin_email,
      password: password
    })

    IO.puts("Default admin user created: #{admin_email}")

  _user ->
    IO.puts("Admin user already exists: #{admin_email}")
end

case Accounts.get_user_by_email(user_email) do
  nil ->
    {:ok, _user} = Accounts.register_user(%{
      first_name: user_flname,
      last_name: user_flname,
      username: user_name,
      email: user_email,
      password: password
    })

    IO.puts("Default user created: #{user_email}")

  _user ->
    IO.puts("User already exists: #{user_email}")
end
