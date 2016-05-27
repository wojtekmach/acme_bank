defmodule BankWeb.AccountController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication

  def show(conn, _params) do
    render conn, "show.html"
  end
end
