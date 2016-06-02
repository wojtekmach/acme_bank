defmodule BankWeb.Deposit do
  import BankWeb.Transaction, only: [credit: 3, debit: 3]

  def build(%BankWeb.Customer{wallet: wallet}, amount_cents) do
    build(wallet, amount_cents)
  end
  def build(%BankWeb.Account{} = wallet, amount_cents) do
    description = "Deposit"

    Ecto.Multi.new
    |> Ecto.Multi.insert(:debit, debit(BankWeb.Ledger.deposits_account, description, amount_cents))
    |> Ecto.Multi.insert(:credit, credit(wallet, description, amount_cents))
  end
end
