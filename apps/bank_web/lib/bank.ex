defmodule Bank do
  alias BankWeb.{Customer, Repo}

  def create_customer!(username) do
    Customer.build(%{username: username})
    |> Repo.insert!
  end
end
