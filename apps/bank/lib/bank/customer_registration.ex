defmodule Bank.CustomerRegistration do
  use Bank.Model

  def create(username, email, password) do
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
end
