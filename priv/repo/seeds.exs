# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Freegiving.Repo.insert!(%Freegiving.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Freegiving.Accounts.register_admin(%{
  email: "jean.f.cloutier@gmail.com",
  password: "12345678abc",
  password_confirmation: "12345678abc"
})

Freegiving.Accounts.register_user(%{
  email: "jf@collaboration-planners.com",
  password: "12345678abc",
  password_confirmation: "12345678abc"
})
