defmodule BankWed.LedgerTest do
  use BankWeb.ModelCase
  alias BankWeb.{Repo, Account, Deposit, Ledger}
  import BankWeb.Transaction

  setup do
    alice = Account.build_wallet("alice") |> Repo.insert!
    bob = Account.build_wallet("bob") |> Repo.insert!

    {:ok, _} = Deposit.build(alice, 100_00) |> Repo.transaction

    {:ok, %{alice: alice, bob: bob}}
  end

  test "write: ok", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", 10_00))
      |> Ecto.Multi.insert(:credit, credit(bob, "", 10_00))

    assert {:ok, _} = Ledger.write(multi)
  end

  test "write: credits not equal debits", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", 10_00))
      |> Ecto.Multi.insert(:credit, credit(bob, "", 9_00))

    assert {:error, :credits_equal_debits, {109_00, 110_00}, _} = Ledger.write(multi)
    assert Ledger.balance(alice) == 100_00
    assert Ledger.balance(bob) == 0
  end

  test "write: insufficient funds", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", 900_00))
      |> Ecto.Multi.insert(:credit, credit(bob, "", 900_00))

    assert {:error, :sufficient_funds, _, _} = Ledger.write(multi)
  end
end
