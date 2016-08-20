defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  @moduletag isolation: :serializable

  test "show", %{conn: conn} do
    {:ok, %{customer: alice}} = Bank.register_customer("alice", "alice@example.com", "secret12")
    Bank.create_deposit!(alice, ~M"10 USD")

    conn = post conn, "/sign_in", %{session: %{email: "alice@example.com", password: "secret12"}}

    conn = get conn, "/account"
    assert conn.status == 200
    assert conn.resp_body =~ "<h2>Account balance</h2>\n\n$10.00"
    assert conn.resp_body =~ "Deposit"
  end

  test "unauthenticated", %{conn: conn} do
    conn = get conn, "/account"
    assert conn.status == 302
  end
end
