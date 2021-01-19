# Script for testing populating the database. You can run it as:
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

Fundraisers.register_payment_service(%{
  name: "PayPal",
  url: "www.paypal.com"
})

Fundraisers.register_contact(%{
  name: "John Q. Manager",
  email: "dev@yourgrocerycard.gives",
  phone: "207-555-1212"
})

Fundraisers.register_contact(%{
  name: "Jean-Francois Cloutier",
  email: "jean.f.cloutier@gmail.com",
  phone: "207-615-3049",
  address: "32 Sawyer St, Portland, ME, 04103"
})

{:ok, fundraiser} =
  Fundraisers.register_fundraiser(
    %{
      name: "CBHS-PAG",
      refill_round_min: 1000,
      card_refill_max: 500,
      card_reserve_low_mark: 1,
      card_reserve_max: 5
    },
    school_name: "Casco Bay High School",
    store_name: "Hannaford",
    store_contact_email: "dev@yourgrocerycard.gives"
  )

Fundraisers.register_gift_card(%{card_number: "6006496950042782613"}, fundraiser_id: fundraiser.id)

Fundraisers.register_fundraiser_admin(
  %{
    user_email: "jean.f.cloutier@gmail.com",
    contact: %{name: "JF Cloutier", email: "jean.f.cloutier@gmail.com", phone: "207-615-3049"},
    primary: true
  },
  fundraiser_id: fundraiser.id
)

Fundraisers.register_payment_method(%{payable_to: "dev@yourgrocerycardgives.com"},
  fundraiser_id: fundraiser.id,
  payment_service_name: "PayPal"
)

{:ok, participant} =
  Fundraisers.register_participant(%{notify_by_email: true, notify_by_text: false},
    contact: %{name: "JF Cloutier", email: "jean.f.cloutier@gmail.com", phone: "207-615-3049"},
    fundraiser_id: fundraiser.id,
    user_email: "jf@collaboration-planners.com"
  )

  # TODO - find an unassigned card to assign. If none, fail.
{:ok, assigned_gift_card} =
  Fundraisers.assign_gift_card(%{},
    participant_id: participant.id
  )

{:ok, card_refill} =
  Fundraisers.request_card_refill(%{amount: 500},
    card_number: assigned_gift_card.card_number,
    payment_service_name: "PayPal"
  )
