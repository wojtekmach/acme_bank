defmodule BankWeb.PageController do
  use BankWeb.Web, :controller

  def index(conn, _params) do
    customers = BankWeb.Repo.all(BankWeb.Customer)
    render conn, "index.html", customers: customers
  end
end
