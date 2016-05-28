defmodule BankWeb.Ledger do
  import Ecto.Query

  alias BankWeb.{Repo, Account, Transaction}

  def balance(%Account{id: id}) do
    from(t in Transaction,
         select: fragment("SUM(CASE WHEN t0.type = 'credit' THEN t0.amount_cents ELSE -t0.amount_cents END)"),
         where: t.account_id == ^id)
    |> Repo.one || 0
  end

  def deposits_account do
    Repo.get_by(Account, name: "Deposits") ||
      Repo.insert!(%Account{name: "Deposits"})
  end

  def transactions(account) do
    id = account.id
    Repo.all(from t in Transaction, where: t.account_id == ^id)
  end
end
