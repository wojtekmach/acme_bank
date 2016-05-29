defmodule BankWeb.SimulationTest do
  use ExUnit.Case, async: true
  import BankWeb.Transaction, only: [credit: 3, debit: 3]
  import BankWeb.Simulation

  setup do
    alice = %BankWeb.Account{id: 1}
    bob = %BankWeb.Account{id: 2}
    {:ok, %{alice: alice, bob: bob}}
  end

  test "perform: ok", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:a, debit(alice, "", 1_00))
      |> Ecto.Multi.insert(:b, credit(bob, "", 1_00))

    assert perform(multi, %{alice.id => 100_00, bob.id => 100_00}) == :ok
  end

  test "perform: credits not equal debits", %{alice: alice} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:a, debit(alice, "", 1_00))

    assert perform(multi, %{alice.id => 0}) == {:error, :credits_not_equal_debits}
  end

  test "perform: insufficient funds", %{alice: alice, bob: bob} do
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:a, debit(alice, "", 1_00))
      |> Ecto.Multi.insert(:b, credit(bob, "", 1_00))

    assert perform(multi, %{alice.id => 0, bob.id => 0}) == {:error, :insufficient_funds}
  end
end
