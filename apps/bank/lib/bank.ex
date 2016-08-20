defmodule Bank do
  @moduledoc ~S"""
  Contains main business logic of the project.

  See `Bank.Ledger` for a double-entry accounting system implementation.
  """

  use Bank.Model

  ## Customers

  def create_customer!(username, email) do
    Customer.build(%{username: username, email: email})
    |> Repo.insert!
  end

  def register_customer(username, email, password) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:customer, Customer.build(%{username: username, email: email}))
    |> Ecto.Multi.run(:account, fn _ ->
      Auth.register(%{email: email, password: password})
    end)
    |> Ecto.Multi.run(:update, fn %{customer: customer, account: account} ->
      Ecto.Changeset.change(customer, auth_account_id: account.id)
      |> Repo.update
    end)
    |> Repo.transaction()
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

  @doc ~S"""
  Returns balance of the customer's wallet account
  """
  def balance(%Customer{wallet: wallet}), do: Ledger.balance(wallet)

  @doc ~S"""
  Returns transactions of the customer's wallet account.
  """
  def transactions(%Customer{wallet: wallet}), do: Ledger.entries(wallet)

  ## Transfers

  def build_transfer(customer) do
    Transfer.changeset(customer, %Transfer{})
  end

  def create_transfer(customer, params) do
    Transfer.create(customer, params)
  end
end
