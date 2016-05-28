defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  test "show", %{conn: conn} do
    alice = BankWeb.Customer.build(%{username: "alice"}) |> BankWeb.Repo.insert!
    {:ok, _} = BankWeb.Deposit.build(alice, 10_00) |> BankWeb.Repo.transaction

    conn = conn |> assign(:current_customer, alice)

    conn = get conn, "/account"
    assert html_response(conn, 200) =~ "<h2>Account balance</h2>\n\n$10.00"
  end

  test "unauthenticated", %{conn: conn} do
    conn = get conn, "/account"
    assert conn.status == 401
  end
end
