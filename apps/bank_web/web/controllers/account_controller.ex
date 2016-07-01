defmodule BankWeb.AccountController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication.Require

  def show(conn, _params) do
    wallet = conn.assigns.current_customer.wallet
    balance = BankWeb.Ledger.balance(wallet)
    transactions = BankWeb.Ledger.transactions(wallet)

    render conn, "show.html", balance: balance, transactions: transactions
  end
end
