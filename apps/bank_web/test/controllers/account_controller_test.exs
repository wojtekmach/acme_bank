defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  test "show", %{conn: conn} do
    alice = BankWeb.Customer.build(%{username: "alice"}) |> BankWeb.Repo.insert!
    conn = conn |> assign(:current_customer, alice)

    {:ok, _} = BankWeb.Deposit.build(alice, 10_00) |> BankWeb.Repo.transaction

    conn = get conn, "/account"
    assert html_response(conn, 200) =~ "Account balance: $10.00"
  end

  test "unauthenticated", %{conn: conn} do
    conn = get conn, "/account"
    assert conn.status == 401
  end
end
