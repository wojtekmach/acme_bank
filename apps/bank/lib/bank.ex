defmodule Bank do
  @moduledoc ~S"""
  Contains main business logic of the project.

  See `Bank.Ledger` for a double-entry accounting system implementation.
  """

  use Bank.Model

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

  ## Ledger

  defdelegate balance(account), to: Ledger
  defdelegate transactions(account), to: Ledger

  ## Transfers

  def build_transfer(customer) do
    Transfer.changeset(customer, %Transfer{})
  end

  def create_transfer(customer, params) do
    Transfer.create(customer, params)
  end
end
