defmodule Freegiving.Repo.Migrations.AddDomainToPaymentServices do
  use Ecto.Migration

  def change do
    alter table("payment_services") do
      add :email_domain, :string
    end
  end
end
