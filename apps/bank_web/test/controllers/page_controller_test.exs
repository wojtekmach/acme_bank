defmodule BankWeb.PageControllerTest do
  use BankWeb.ConnCase

  setup do
    Bank.create_customer!("alice", "alice@example.com")
    :ok
  end

  test "index: unauthenticated", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302) =~ ~r{"/sign_in"}
  end

  test "index: authenticated", %{conn: conn} do
    conn = post conn, "/sign_in_as/alice"
    assert html_response(conn, 302) =~ ~r{"/"}

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Signed in as alice"

    conn = get conn, "/sign_out"
    assert html_response(conn, 302) =~ ~r{"/"}

    conn = get conn, "/"
    assert html_response(conn, 302) =~ ~r{"/sign_in"}
	end
end
