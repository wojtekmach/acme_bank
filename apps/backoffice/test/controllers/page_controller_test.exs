defmodule Backoffice.PageControllerTest do
  use Backoffice.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/backoffice"
    assert html_response(conn, 200) =~ "Welcome to Acme Bank Backoffice"
  end
end
