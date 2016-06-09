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
    assert {:ok, _} = Transfer.create(alice, %{amount_cents: 2_00, destination_username: "bob"})
    assert Ledger.balance(alice.wallet) == 8_00
    assert Ledger.balance(bob.wallet) == 2_00
  end

  test "create: invalid amount", %{alice: alice} do
    assert {:error, %{errors: [amount_cents: {"is invalid", _}]}} =
           Transfer.create(alice, %{amount_cents: "invalid", destination_username: "bob"})
  end

  test "create: insufficient funds", %{alice: alice} do
    assert {:error, %{errors: [amount_cents: {"insufficient funds", _}]}} =
           Transfer.create(alice, %{amount_cents: 999_00, destination_username: "bob"})
  end

  test "create: cannot transfer to the same account", %{alice: alice} do
    assert {:error, %{errors: [destination_username: {"cannot transfer to the same account", _}]}} =
           Transfer.create(alice, %{amount_cents: 2_00, destination_username: "alice"})
  end

  test "create: invalid destination", %{alice: alice} do
    assert {:error, %{errors: [destination_username: {"is invalid", _}]}} =
           Transfer.create(alice, %{amount_cents: 2_00, destination_username: "invalid"})
  end
end
