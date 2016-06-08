defmodule BankWeb.TransferTest do
  use BankWeb.ModelCase
  alias BankWeb.{Repo, Customer, Deposit, Ledger, Transfer}

  @moduletag transaction_isolation: :serializable

  setup do
    alice = Customer.build(%{username: "alice"}) |> Repo.insert!
    bob = Customer.build(%{username: "bob"}) |> Repo.insert!
    {:ok, _} = Deposit.build(alice, 10_00) |> Ledger.write

    {:ok, %{alice: alice, bob: bob}}
  end

  test "create: success", %{alice: alice, bob: bob} do
    assert Transfer.create(alice, %{amount_cents: 2_00, destination_account_id: bob.wallet.id}) == :ok
    assert Ledger.balance(alice.wallet) == 8_00
    assert Ledger.balance(bob.wallet) == 2_00
  end

  test "create: invalid amount", %{alice: alice, bob: bob} do
    assert {:error, %{errors: [amount_cents: {"is invalid", _}]}} =
           Transfer.create(alice, %{amount_cents: "invalid", destination_account_id: bob.wallet.id})
  end

  test "create: insufficient funds", %{alice: alice, bob: bob} do
    assert {:error, %{errors: [amount_cents: {"insufficient funds", _}]}} =
           Transfer.create(alice, %{amount_cents: 999_00, destination_account_id: bob.wallet.id})
  end

  test "create: cannot transfer to the same account", %{alice: alice} do
    assert {:error, %{errors: [destination_account_id: {"cannot transfer to the same account", _}]}} =
           Transfer.create(alice, %{amount_cents: 2_00, destination_account_id: alice.wallet.id})
  end

  @tag :skip
  test "create: invalid destination", %{alice: alice} do
    assert {:error, %{errors: [destination_account_id: {"is invalid", _}]}} =
           Transfer.create(alice, %{amount_cents: 2_00, destination_account_id: 42})
  end
end
