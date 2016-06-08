defmodule BankWeb.LedgerTest do
  use BankWeb.ModelCase
  alias BankWeb.{Repo, Account, Deposit, Ledger}
  import BankWeb.Transaction, only: [credit: 3, debit: 3]

  @moduletag transaction_isolation: :serializable

  setup _tags do
    alice = Account.build_wallet("alice") |> Repo.insert!
    bob = Account.build_wallet("bob") |> Repo.insert!

    {:ok, _} = Deposit.build(alice, 100_00) |> Ledger.write

    {:ok, %{alice: alice, bob: bob}}
  end

  test "balance" do
    asset = Account.build_asset("asset") |> Repo.insert!
    wallet = Account.build_wallet("wallet") |> Repo.insert!

    assert Ledger.balance(asset) == 0
    assert Ledger.balance(wallet) == 0

    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(asset, "", 10_00))
      |> Ecto.Multi.insert(:credit, credit(wallet, "", 10_00))
    {:ok, _} = Repo.transaction(multi)

    assert Ledger.balance(asset) == 10_00
    assert Ledger.balance(wallet) == 10_00
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
