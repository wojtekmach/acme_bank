defmodule Bank.Deposit do
  use Bank.Model

  def build(%Customer{wallet: wallet}, %Money{} = amount) do
    build(wallet, amount)
  end
  def build(%Ledger.Account{} = wallet, %Money{} = amount) do
    description = "Deposit"

    [
      {:debit, Ledger.deposits_account, description, amount},
      {:credit, wallet, description, amount},
    ]
  end
end
