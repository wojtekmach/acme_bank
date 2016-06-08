defmodule BankWeb.TransferControllerTest do
  use BankWeb.ConnCase
  alias BankWeb.{Customer, Deposit, Ledger, Repo}

  @moduletag transaction_isolation: :serializable

  setup do
    alice = Customer.build(%{username: "alice"}) |> Repo.insert!
    bob = Customer.build(%{username: "bob"}) |> Repo.insert!
    {:ok, _} = Deposit.build(alice, 10_00) |> Ledger.write

    conn = assign(build_conn(), :current_customer, alice)

    {:ok, %{conn: conn, alice: alice, bob: bob}}
  end

  test "create: success", %{conn: conn} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: 2_00, destination_username: "bob"}}
    assert html_response(conn, 302)
  end

  test "create: invalid amount", %{conn: conn} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: "bad"}}
    assert html_response(conn, 200) =~ "is invalid"
  end
end
