defmodule BankWeb.Deposit do
  import BankWeb.Transaction, only: [credit: 3, debit: 3]

  def build(%BankWeb.Customer{wallet: wallet}, %Money{} = amount) do
    build(wallet, amount)
  end
  def build(%BankWeb.Account{} = wallet, %Money{} = amount) do
    description = "Deposit"

    Ecto.Multi.new
    |> Ecto.Multi.insert(:debit, debit(BankWeb.Ledger.deposits_account, description, amount))
    |> Ecto.Multi.insert(:credit, credit(wallet, description, amount))
  end
end
