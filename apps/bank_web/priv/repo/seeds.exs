if Mix.env == :dev do

  alice = BankWeb.Customer.build(%{username: "alice"}) |> BankWeb.Repo.insert!
  {:ok, _} = BankWeb.Deposit.build(alice, 10_00) |> BankWeb.Ledger.write

  BankWeb.Customer.build(%{username: "bob"}) |> BankWeb.Repo.insert!

end
