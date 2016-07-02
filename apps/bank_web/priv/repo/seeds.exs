if Mix.env == :dev do

  import Money

  alice = BankWeb.Customer.build(%{username: "alice"}) |> BankWeb.Repo.insert!
  {:ok, _} = BankWeb.Deposit.build(alice, ~M"10 USD") |> BankWeb.Ledger.write

  BankWeb.Customer.build(%{username: "bob"}) |> BankWeb.Repo.insert!

end
