defmodule Bank.TransferTest do
  use Bank.Case

  @moduletag isolation: :serializable

  @valid_params %{
    amount_string: "2.01",
    destination_username: "bob",
    description: "Lunch money"
  }

  setup do
    :ok = Messenger.Local.setup()

    alice = Bank.create_customer!("alice", "alice@example.com")
    bob = Bank.create_customer!("bob", "bob@example.com")
    Bank.create_deposit!(alice, ~M"10 USD")

    {:ok, %{alice: alice, bob: bob}}
  end

  test "create: success", %{alice: alice, bob: bob} do
    assert {:ok, _} = Transfer.create(alice, @valid_params)
    assert Ledger.balance(alice.wallet) == ~M"7.99 USD"
    assert Ledger.balance(bob.wallet) == ~M"2.01 USD"

    assert Messenger.Local.subjects_for("bob") == ["You've received 2.01 USD from alice"]
  end

  test "create: invalid amount", %{alice: alice} do
    assert {:error, %{errors: [amount_string: {"is invalid", _}]}} =
           Transfer.create(alice, %{@valid_params | amount_string: "invalid"})

    assert {:error, %{errors: [amount_string: {"is invalid", _}]}} =
           Transfer.create(alice, %{@valid_params | amount_string: "-2.00"})
  end

  test "create: insufficient funds", %{alice: alice} do
    assert {:error, %{errors: [amount_string: {"insufficient funds", _}]}} =
           Transfer.create(alice, %{@valid_params | amount_string: "999.00"})
  end

  test "create: blank destination", %{alice: alice} do
    assert {:error, %{errors: [destination_username: {"can't be blank", _}]}} =
           Transfer.create(alice, %{@valid_params | destination_username: ""})
  end

  test "create: cannot transfer to the same account", %{alice: alice} do
    assert {:error, %{errors: [destination_username: {"cannot transfer to the same account", _}]}} =
           Transfer.create(alice, %{@valid_params | destination_username: "alice"})
  end

  test "create: invalid destination", %{alice: alice} do
    assert {:error, %{errors: [destination_username: {"is invalid", _}]}} =
           Transfer.create(alice, %{@valid_params | destination_username: "invalid"})
  end
end
