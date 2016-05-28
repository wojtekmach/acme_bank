defmodule BankWeb.AccountController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication.Require

  def show(conn, _params) do
    balance = BankWeb.Account.balance(conn.assigns.current_customer.wallet)
    render conn, "show.html", balance: balance
  end
end
