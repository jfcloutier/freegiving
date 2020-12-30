defmodule Freegiving.Fundraisers do
  @moduledoc "The Fundraisers context"

  import Ecto.Query, warn: false
  alias Freegiving.Repo
  alias Freegiving.Fundraisers.{School, Store, Contact, Fundraiser}

  def register_school(attrs) do
    %School{}
    |> School.school_changeset(attrs)
    |> Repo.insert()
  end

  def register_store(attrs) do
    %Store{}
    |> Store.store_changeset(attrs)
    |> Repo.insert()
  end

  def register_contact(attrs) do
    %Contact{}
    |> Contact.contact_changeset(attrs)
    |> Repo.insert()
  end

  def register_fundraiser(attrs,
        school_name: school_name,
        store_name: store_name,
        store_contact_email: store_contact_email
      ) do
    store = Repo.get_by(Store, name: store_name)
    school = Repo.get_by(School, name: school_name)
    contact = Repo.get_by(Contact, email: store_contact_email)

    if store != nil and school != nil and contact != nil do
      %Fundraiser{school_id: school.id, store_id: store.id, store_contact_id: contact.id}
      |> Fundraiser.fundraiser_changeset(attrs)
      |> Repo.insert()
    else
      {:error, :failed}
    end
  end
end
