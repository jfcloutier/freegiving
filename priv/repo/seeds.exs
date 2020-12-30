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

alias Freegiving.{Accounts, Fundraisers}

Accounts.register_admin(%{
  email: "jean.f.cloutier@gmail.com",
  password: "12345678abc",
  password_confirmation: "12345678abc"
})

Accounts.register_user(%{
  email: "jf@collaboration-planners.com",
  password: "12345678abc",
  password_confirmation: "12345678abc"
})

Fundraisers.register_school(%{
  name: "Casco Bay High School",
  short_name: "cbhs",
  address: "196 Allen Ave, Portland, ME 04103"
})

Fundraisers.register_store(%{
  name: "Hannaford",
  short_name: "hannaford",
  address: "145 Pleasant Hill Road, Scarborough, ME 04074"
})

Fundraisers.register_contact(%{
  name: "John Q. Manager",
  email: "john.q.manager@hannaford.com",
  phone: "207-555-1212"
})

Fundraisers.register_fundraiser(%{refill_round_min: 1000},
  school_name: "Casco Bay High School",
  store_name: "Hannaford",
  store_contact_email: "john.q.manager@hannaford.com"
)
