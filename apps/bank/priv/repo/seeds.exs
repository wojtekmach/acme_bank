if Mix.env == :dev do

  import Money

  alice = Bank.create_customer!("alice")
  Bank.create_deposit!(alice, ~M"10 USD")

  bob = Bank.create_customer!("bob")

  # TODO: so far this is the only reason Bank depends on Auth. Reconsider?
  {:ok, alice_account} = Auth.register(%{email: "alice@example.com", password: "secret12"})
  Bank.Repo.update!(Ecto.Changeset.change(alice, auth_account_id: alice_account.id))

  {:ok, bob_account} = Auth.register(%{email: "bob@example.com", password: "secret12"})
  Bank.Repo.update!(Ecto.Changeset.change(bob, auth_account_id: bob_account.id))

end
