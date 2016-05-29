defmodule BankWeb.TransferController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication.Require

  def new(conn, _params) do
    customer = conn.assigns.current_customer
    transfer = BankWeb.Transfer.changeset(customer, %BankWeb.Transfer{})
    render conn, "new.html", transfer: transfer
  end

  def create(conn, %{"transfer" => transfer_params}) do
    customer = conn.assigns.current_customer

    case BankWeb.Transfer.create(customer, transfer_params) do
      :ok ->
        redirect conn, to: account_path(conn, :show)
      {:error, changeset} ->
        changeset = %{changeset | action: :transfer}
        render conn, "new.html", transfer: changeset
    end
  end
end
