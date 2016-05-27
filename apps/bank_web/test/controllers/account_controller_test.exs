defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  test "show", %{conn: conn} do
    alice = BankWeb.Repo.insert!(%BankWeb.Customer{username: "alice"})
    conn = conn |> assign(:current_customer, alice)

    conn = get conn, "/account"
    assert html_response(conn, 200) =~ "Account balance: $0.00"
  end

  test "unauthenticated", %{conn: conn} do
    conn = get conn, "/account"
    assert conn.status == 401
  end
end
