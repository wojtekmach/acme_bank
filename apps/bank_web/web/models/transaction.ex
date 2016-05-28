defmodule BankWeb.Transaction do
  use BankWeb.Web, :model

  schema "transactions" do
    field :type, :string
    field :description, :string
    field :amount_cents, :integer
    belongs_to :account, BankWeb.Account

    timestamps
  end
end
