BankWeb.Repo.delete_all(BankWeb.Account)
BankWeb.Repo.insert!(%BankWeb.Account{name: "Deposits"})

BankWeb.Repo.delete_all(BankWeb.Customer)
BankWeb.Customer.build(%{username: "alice"}) |> BankWeb.Repo.insert!
BankWeb.Customer.build(%{username: "bob"}) |> BankWeb.Repo.insert!
