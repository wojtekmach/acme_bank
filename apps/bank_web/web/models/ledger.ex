defmodule BankWeb.Ledger do
  import Ecto.Query

  alias BankWeb.{Repo, Account, Transaction}

  def balance(%Account{id: id, type: type}) do
    q = from(t in Transaction,
             select: fragment("SUM(CASE WHEN t0.type = 'credit' THEN t0.amount_cents ELSE -t0.amount_cents END)"),
             where: t.account_id == ^id)

    balance = Repo.one(q) || 0
    do_balance(balance, type)
  end
  defp do_balance(balance, "liability"), do: +balance
  defp do_balance(balance, "asset"),     do: -balance

  def deposits_account do
    Repo.get_by(Account, name: "Deposits") ||
      Repo.insert!(Account.build_asset("Deposits"))
  end

  def transactions(%Account{id: id}) do
    Repo.all(from t in Transaction, where: t.account_id == ^id)
  end

  def write(multi) do
    multi =
      multi
      |> Ecto.Multi.run(:credits_equal_debits, &credits_equal_debits/1)
      |> Ecto.Multi.run(:sufficient_funds, &sufficient_funds/1)

    Repo.multi_transaction_with_isolation(multi, :serializable)
  end

  defp credits_equal_debits(_data) do
    credits = Repo.one!(from(t in Transaction, select: sum(t.amount_cents), where: t.type == "credit"))
    debits  = Repo.one!(from(t in Transaction, select: sum(t.amount_cents), where: t.type == "debit"))

    if credits == debits do
      {:ok, 0}
    else
      {:error, {credits, debits}}
    end
  end

  defp sufficient_funds(data) do
    balances =
      Enum.map(data, fn
        {_, %Transaction{account: account}} -> account
        _ -> nil
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.into(%{}, fn account -> {account.id, balance(account)} end)

    if Enum.all?(balances, fn {_, balance} -> balance >= 0 end) do
      {:ok, balances}
    else
      {:error, balances}
    end
  end
end
