defmodule BankWeb.Authentication do
  import Plug.Conn

  def init([]), do: []

  def call(conn, _opts) do
    id = get_session(conn, :customer_id)
    customer = id && BankWeb.Repo.get!(BankWeb.Customer, id)

    conn
    |> assign(:current_customer, customer)
  end
end
