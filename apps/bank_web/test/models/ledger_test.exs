defmodule BankWeb.LedgerTest do
  use BankWeb.ModelCase
  alias BankWeb.{Repo, Account, Deposit, Ledger}
  import BankWeb.Transaction, only: [credit: 3, debit: 3]

  @moduletag isolation: :serializable

  setup _tags do
    alice = Account.build_wallet("alice") |> Repo.insert!
    bob = Account.build_wallet("bob") |> Repo.insert!

    {:ok, _} = Deposit.build(alice, ~M"100 USD") |> Ledger.write

    {:ok, %{alice: alice, bob: bob}}
  end

  test "balance" do
    asset = Account.build_asset("asset") |> Repo.insert!
    wallet = Account.build_wallet("wallet") |> Repo.insert!

    assert Ledger.balance(asset) == ~M"0 USD"
    assert Ledger.balance(wallet) == ~M"0 USD"

    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(asset, "", ~M"10 USD"))
      |> Ecto.Multi.insert(:credit, credit(wallet, "", ~M"10 USD"))
    {:ok, _} = Repo.transaction(multi)

    assert Ledger.balance(asset) == ~M"10 USD"
    assert Ledger.balance(wallet) == ~M"10 USD"
  end

  test "write: ok", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", ~M"10 USD"))
      |> Ecto.Multi.insert(:credit, credit(bob, "", ~M"10 USD"))

    assert {:ok, _} = Ledger.write(multi)
  end

  test "write: credits not equal debits", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", ~M"10 USD"))
      |> Ecto.Multi.insert(:credit, credit(bob, "", ~M"9 USD"))

    assert {:error, :credits_equal_debits, {109_00, 110_00}, _} = Ledger.write(multi)
    assert Ledger.balance(alice) == ~M"100 USD"
    assert Ledger.balance(bob) == ~M"0 USD"
  end

  test "write: insufficient funds", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:debit, debit(alice, "", ~M"900 USD"))
      |> Ecto.Multi.insert(:credit, credit(bob, "", ~M"900 USD"))

    assert {:error, :sufficient_funds, _, _} = Ledger.write(multi)
  end
end
