defmodule BankWeb.Authentication do
  import Plug.Conn

  def init([]), do: []

  def call(%{assigns: %{current_customer: %{}}} = conn, _opts), do: conn
  def call(conn, _opts) do
    id = get_session(conn, :customer_id)
    customer = if id, do: Bank.find_customer!(id: id)

    conn
    |> assign(:current_customer, customer)
  end

  def require_authenticated(%{assigns: %{current_customer: %{}}} = conn, _opts), do: conn
  def require_authenticated(conn, _opts) do
    conn
    |> Phoenix.Controller.put_flash(:alert, "You must be signed in to access that page")
    |> Phoenix.Controller.redirect(to: "/sign_in")
    |> halt()
  end
end
