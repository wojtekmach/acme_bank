defmodule BankWeb.Authentication.Load do
  import Plug.Conn

  def init([]), do: []

  def call(%{assigns: %{current_customer: %{}}} = conn, _opts), do: conn
  def call(conn, _opts) do
    id = get_session(conn, :customer_id)
    customer = if id, do: Bank.find_customer!(id: id)

    conn
    |> assign(:current_customer, customer)
  end
end

defmodule BankWeb.Authentication.Require do
  import Plug.Conn

  def init([]), do: []

  def call(%{assigns: %{current_customer: %{}}} = conn, _opts), do: conn
  def call(conn, _opts) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt
  end
end
