if Mix.env == :dev do

  import Money

  alice = Bank.create_customer!("alice")
  Bank.create_deposit!(alice, ~M"10 USD")

  Bank.create_customer!("bob")

end
