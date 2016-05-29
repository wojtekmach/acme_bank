defmodule BankWeb.Simulation do
  @moduledoc """
  Simulates transactions. Makes sure that a given set of transactions
  obeys these constraints:

  - sum(credits) == sum(debits)
  - no account is overdrawn
  """

  def perform(multi, balances) do
    initial = %{
      credit: 0,
      debit: 0,
      balances: balances,
    }

    result =
      Enum.reduce(multi.operations, initial, fn {_, {:changeset, changeset, _}}, state ->
        txn = changeset.data
        type = String.to_atom(txn.type)
        change = if type == :credit, do: +txn.amount_cents, else: -txn.amount_cents
        balances = Map.put(state.balances, txn.account.id, Map.fetch!(state.balances, txn.account.id) + change)

        %{state | type => Map.fetch!(state, type) + txn.amount_cents,
                  balances: balances}
      end)

    cond do
      result.credit != result.debit ->
        {:error, :credits_not_equal_debits}
      Enum.any?(Map.values(result.balances), & &1 < 0) ->
        {:error, :insufficient_funds}
      true ->
        :ok
    end
  end
end
