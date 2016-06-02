defmodule BankWed.LedgerTest do
  use BankWeb.ModelCase
  alias BankWeb.{Repo, Account, Deposit, Ledger}
  import BankWeb.Transaction

  setup do
    alice = Repo.insert!(%Account{name: "alice"})
    bob = Repo.insert!(%Account{name: "bob"})

    {:ok, _} = Deposit.build(alice, 100_00) |> Repo.transaction

    {:ok, %{alice: alice, bob: bob}}
  end

  test "write: ok", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", 10_00))
      |> Ecto.Multi.insert(:credit, credit(bob, "", 10_00))

    assert Ledger.write(multi) == :ok
  end

  test "write: credits not equal debits", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", 10_00))
      |> Ecto.Multi.insert(:credit, credit(bob, "", 9_00))

    assert Ledger.write(multi) == {:error, :credits_not_equal_debits}
  end

  test "write: insufficient funds", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", 900_00))
      |> Ecto.Multi.insert(:credit, credit(bob, "", 900_00))

    assert Ledger.write(multi) == {:error, :insufficient_funds}
  end
end
