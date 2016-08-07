defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  @moduletag isolation: :serializable

  test "show", %{conn: conn} do
    alice = Bank.create_customer!("alice", "alice@example.com")
    Bank.create_deposit!(alice, ~M"10 USD")

    conn = conn |> assign(:current_customer, alice)

    conn = get conn, "/account"
    assert conn.status == 200
    assert conn.resp_body =~ "<h2>Account balance</h2>\n\n$10.00"
    assert conn.resp_body =~ "Deposit"

    # TODO: allow custom deposit description and assert it here
  end

  test "unauthenticated", %{conn: conn} do
    conn = get conn, "/account"
    assert conn.status == 302
  end
end
