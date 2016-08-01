if Mix.env == :dev do

  import Money

  {:ok, %{customer: alice}} = Bank.register_customer("alice", "alice@example.com", "secret12")
  Bank.create_deposit!(alice, ~M"10 USD")

  {:ok, %{customer: bob}} = Bank.register_customer("bob", "bob@example.com", "secret12")

end
