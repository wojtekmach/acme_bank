defmodule BankWeb.PageControllerTest do
  use BankWeb.ConnCase

  setup do
    BankWeb.Repo.insert!(%BankWeb.Customer{username: "alice"})
    :ok
  end

  test "index: unauthenticated", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign in as alice"
  end

  test "index: authenticated", %{conn: conn} do
    conn = post conn, "/sign_in_as/alice"
    assert conn.status == 302

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Signed in as alice"

    conn = get conn, "/sign_out"
    assert conn.status == 302

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign in as alice"
	end
end
