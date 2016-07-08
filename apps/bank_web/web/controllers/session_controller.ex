defmodule BankWeb.SessionController do
  use BankWeb.Web, :controller

  def sign_in_as(conn, %{"username" => username}) do
		customer = Repo.get_by!(Customer, username: username)

    conn
    |> put_session(:customer_id, customer.id)
    |> redirect(to: "/")
  end

  def sign_out(conn, _params) do
    conn
    |> clear_session
    |> redirect(to: "/")
  end
end
