defmodule Bank do
  alias BankWeb.{Customer, Deposit, Ledger, Repo}

  ## Customers

  def create_customer!(username) do
    Customer.build(%{username: username})
    |> Repo.insert!
  end

  def find_customer!(clauses) do
    Repo.get_by!(Customer, clauses)
    |> Repo.preload(:wallet)
  end

  def customers do
    Repo.all(Customer)
  end

  ## Deposits

  def create_deposit!(account, amount) do
    {:ok, result} =
      Deposit.build(account, amount)
      |> Ledger.write
    result
  end
end
