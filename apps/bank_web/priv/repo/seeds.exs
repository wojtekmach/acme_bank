if Mix.env == :dev do

  import Money

  alice = Bank.create_customer!("alice")
  {:ok, _} = BankWeb.Deposit.build(alice, ~M"10 USD") |> BankWeb.Ledger.write

  Bank.create_customer!("bob")

end
