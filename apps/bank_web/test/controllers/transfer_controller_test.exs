defmodule BankWeb.TransferControllerTest do
  use BankWeb.ConnCase

  @moduletag isolation: :serializable

  setup do
    :ok = Messenger.Test.setup()
    alice = Customer.build(%{username: "alice"}) |> Repo.insert!
    bob = Customer.build(%{username: "bob"}) |> Repo.insert!
    {:ok, _} = Deposit.build(alice, ~M"10 USD") |> Ledger.write

    conn = assign(build_conn(), :current_customer, alice)

    {:ok, %{conn: conn, alice: alice, bob: bob}}
  end

  test "create: success", %{conn: conn} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: 2_00, destination_username: "bob"}}
    assert html_response(conn, 302)
    assert Messenger.Test.subjects_for("bob") == ["You've received $2.00 from alice"]
  end

  test "create: invalid amount", %{conn: conn} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: "bad"}}
    assert html_response(conn, 200) =~ "is invalid"
  end
end
