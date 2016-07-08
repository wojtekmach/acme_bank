defmodule Bank.Deposit do
  use Bank.Model
  import Transaction, only: [credit: 3, debit: 3]

  def build(%Customer{wallet: wallet}, %Money{} = amount) do
    build(wallet, amount)
  end
  def build(%Account{} = wallet, %Money{} = amount) do
    description = "Deposit"

    Ecto.Multi.new
    |> Ecto.Multi.insert(:debit, debit(Ledger.deposits_account, description, amount))
    |> Ecto.Multi.insert(:credit, credit(wallet, description, amount))
  end
end
