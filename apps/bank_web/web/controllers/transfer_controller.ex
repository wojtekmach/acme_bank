defmodule BankWeb.TransferController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication.Require

  def new(conn, _params) do
    customer = conn.assigns.current_customer
    transfer = Bank.build_transfer(customer)
    render conn, "new.html", transfer: transfer
  end

  def create(conn, %{"transfer" => transfer_params}) do
    customer = conn.assigns.current_customer

    case Bank.create_transfer(customer, transfer_params) do
      {:ok, transfer} ->
        send_message(transfer)
        redirect conn, to: account_path(conn, :show)
      {:error, changeset} ->
        changeset = %{changeset | action: :transfer}
        render conn, "new.html", transfer: changeset
    end
  end

  defp send_message(transfer) do
    subject = "You've received #{transfer.amount} from #{transfer.source_customer.username}"
    :ok = Messenger.send(transfer.destination_username, subject, subject)
  end
end
