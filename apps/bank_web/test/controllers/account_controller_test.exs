defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase
  alias BankWeb.{Customer, Deposit, Ledger, Repo}

  @moduletag transaction_isolation: :serializable

  test "show", %{conn: conn} do
    alice = Customer.build(%{username: "alice"}) |> Repo.insert!
    {:ok, _} = Deposit.build(alice, 10_00) |> Ledger.write

    conn = conn |> assign(:current_customer, alice)

    conn = get conn, "/account"
    assert html_response(conn, 200) =~ "<h2>Account balance</h2>\n\n$10.00"
  end

  test "unauthenticated", %{conn: conn} do
    conn = get conn, "/account"
    assert conn.status == 401
  end
end
