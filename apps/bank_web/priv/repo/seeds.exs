if Mix.env == :dev do

  alice = BankWeb.Customer.build(%{username: "alice"}) |> BankWeb.Repo.insert!
  {:ok, _} = BankWeb.Deposit.build(alice, Money.new("10 USD")) |> BankWeb.Ledger.write

  BankWeb.Customer.build(%{username: "bob"}) |> BankWeb.Repo.insert!

end
