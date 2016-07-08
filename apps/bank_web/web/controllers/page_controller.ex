defmodule BankWeb.PageController do
  use BankWeb.Web, :controller

  def index(conn, _params) do
    customers = Bank.customers
    render conn, "index.html", customers: customers
  end
end
