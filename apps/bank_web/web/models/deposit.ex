defmodule BankWeb.Deposit do
  import BankWeb.Transaction, only: [credit: 3, debit: 3]

  def build(customer, amount_cents) do
    description = "Deposit"

    Ecto.Multi.new
    |> Ecto.Multi.insert(:debit, debit(BankWeb.Ledger.deposits_account, description, amount_cents))
    |> Ecto.Multi.insert(:credit, credit(customer.wallet, description, amount_cents))
  end
end
