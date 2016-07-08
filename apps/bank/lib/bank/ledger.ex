defmodule Bank.Ledger do
  @moduledoc ~S"""
  A simple implementation of double-entry accounting system.

  Basically, we store every `Bank.Transaction` twice - once for each account affected.
  Thus, if Alice transfers $10.00 to Bob  we'll have two transactions:

  - debit Alice's account for $10.00
  - credit Bob's account for $10.00

  `Bank.Transaction` can be a credit or a debit. Depending on `Bank.Account`'s type, a credit
  can result in the increase (or decrease) of that accounts' balance. See `balance/1`.

	Double-entry accounting system implementation is usually required for compliance with other financial institutions.

  See [Wikipedia entry for more information](https://en.wikipedia.org/wiki/Double-entry_bookkeeping_system#Debits_and_credits)
  """

  use Bank.Model

  @doc ~S"""
  Returns account's balance.
  
  We calculate balance over all account's transaction.
  Balance increases or decreases are based on `Bank.Account`'s type
  and `Bank.Transaction`'s type according to this table:
	
                | Debit    | Credit
      ----------|----------|---------
      Asset     | Increase | Decrease
      Liability | Decrease | Increase

  """
  def balance(%Account{id: id, type: type, currency: currency}) do
    q = from(t in Transaction,
             select: fragment("SUM(CASE WHEN t0.type = 'credit' THEN (t0.amount).cents ELSE -(t0.amount).cents END)"),
             where: t.account_id == ^id)

    balance = Repo.one(q) || 0
    balance = do_balance(balance, type)
    %Money{cents: balance, currency: currency}
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
    credits = Repo.one!(from(t in Transaction, select: fragment("SUM((t0.amount).cents)"), where: t.type == "credit"))
    debits  = Repo.one!(from(t in Transaction, select: fragment("SUM((t0.amount).cents)"), where: t.type == "debit"))

    if credits == debits do
      {:ok, 0}
    else
      {:error, {credits, debits}}
    end
  end

  defp sufficient_funds(data) do
    balances =
      Enum.reduce(data, %{}, fn
        {_, %Transaction{account: account}}, acc -> Map.put(acc, account.id, balance(account))
        _, acc -> acc
      end)

    if Enum.all?(balances, fn {_, balance} -> balance.cents >= 0 end) do
      {:ok, balances}
    else
      {:error, balances}
    end
  end
end
