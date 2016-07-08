defmodule BankWeb.AccountController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication.Require

  def show(conn, _params) do
    wallet = conn.assigns.current_customer.wallet
    balance = Bank.balance(wallet)
    transactions = Bank.transactions(wallet)

    render conn, "show.html", balance: balance, transactions: transactions
  end
end
