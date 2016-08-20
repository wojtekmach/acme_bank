defmodule BankWeb.AccountController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication.Require

  def show(conn, _params) do
    customer = conn.assigns.current_customer
    balance = Bank.balance(customer)
    transactions = Bank.transactions(customer)

    render conn, "show.html", balance: balance, transactions: transactions
  end
end
