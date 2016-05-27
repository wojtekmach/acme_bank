BankWeb.Repo.delete_all(BankWeb.Customer)
BankWeb.Repo.insert!(%BankWeb.Customer{username: "alice"})
BankWeb.Repo.insert!(%BankWeb.Customer{username: "bob"})
