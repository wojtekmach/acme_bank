defmodule BankWeb.TransferController do
  use BankWeb.Web, :controller
  plug :require_authenticated

  def new(conn, _params) do
    customer = conn.assigns.current_customer
    transfer = Bank.build_transfer(customer)
    render conn, "new.html", transfer: transfer
  end

  def create(conn, %{"transfer" => transfer_params}) do
    customer = conn.assigns.current_customer

    case Bank.create_transfer(customer, transfer_params) do
      {:ok, _transfer} ->
        redirect conn, to: account_path(conn, :show)
      {:error, changeset} ->
        changeset = %{changeset | action: :transfer}
        render conn, "new.html", transfer: changeset
    end
  end
end
