defmodule Bank.Ledger do
  @moduledoc ~S"""
  A simple implementation of double-entry accounting system.

  Basically, we store every `Bank.Ledger.Entry` twice - once for each account affected.
  Thus, if Alice transfers $10.00 to Bob  we'll have two entries:

  - debit Alice's account for $10.00
  - credit Bob's account for $10.00

  `Bank.Ledger.Entry` can be a credit or a debit. Depending on `Bank.Ledger.Account`'s type,
  a credit can result in the increase (or decrease) of that accounts' balance.
  See `balance/1`.

  Double-entry accounting system implementation is usually required for
  compliance with other financial institutions.

  See [Wikipedia entry for more information](https://en.wikipedia.org/wiki/Double-entry_bookkeeping_system#Debits_and_credits)
  """

  use Bank.Model

  alias Bank.Ledger.{Account, Entry}

  @doc ~S"""
  Creates a wallet account for a given `username`.
  """
  def create_wallet!(username) do
    Account.build_wallet(username)
    |> Repo.insert!
  end

  @doc ~S"""
  Returns account's balance as `Money`.
  
  We calculate balance over all account's entry.
  Balance increases or decreases are based on `Bank.Account`'s type
  and `Bank.Entry`'s type according to this table:
	
                | Debit    | Credit
      ----------|----------|---------
      Asset     | Increase | Decrease
      Liability | Decrease | Increase

  """
  def balance(%Account{id: id, type: type, currency: currency}) do
    q = from(t in Entry,
             select: fragment("SUM(CASE WHEN b0.type = 'credit' THEN (b0.amount).cents ELSE -(b0.amount).cents END)"),
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

  def entries(%Account{id: id}) do
    Repo.all(from t in Entry, where: t.account_id == ^id)
  end

  def write(entries) do
    Repo.transaction_with_isolation(fn ->
      with :ok <- same_currencies(entries),
           {:ok, persisted_entries} <- insert(entries),
           :ok <- credits_equal_debits(),
           :ok <- sufficient_funds(persisted_entries) do
        persisted_entries
      else
        {:error, reason} ->
          Repo.rollback(reason)
      end
    end, level: :serializable)
  end

  defp same_currencies(entries) do
    {_, _, _, %Money{currency: currency}} = hd(entries)
    currencies =
      Enum.flat_map(entries, fn {_, %Account{currency: a}, _, %Money{currency: b}} -> [a, b] end)

    if Enum.uniq(currencies) == [currency] do
      :ok
    else
      {:error, :different_currencies}
    end
  end

  defp insert(entries) do
    entries =
      Enum.map(entries, fn tuple ->
        Entry.from_tuple(tuple)
        |> Repo.insert!
      end)
    {:ok, entries}
  end

  defp credits_equal_debits do
    q = from e in Entry, select: fragment("SUM((b0.amount).cents)")
    credits = Repo.one!(from(e in q, where: e.type == "credit"))
    debits  = Repo.one!(from(e in q, where: e.type == "debit"))

    if credits == debits do
      :ok
    else
      {:error, :credits_not_equal_debits}
    end
  end

  defp sufficient_funds(entries) do
    accounts = Enum.map(entries, & &1.account)

    if Enum.all?(accounts, fn account -> balance(account).cents >= 0 end) do
      :ok
    else
      {:error, :insufficient_funds}
    end
  end
end
