defmodule BankWeb.TransferController do
  use BankWeb.Web, :controller

  plug BankWeb.Authentication.Require

  def new(conn, _params) do
    transfer = BankWeb.Transfer.changeset(%BankWeb.Transfer{})
    render conn, "new.html", transfer: transfer
  end

  def create(conn, %{"transfer" => transfer_params}) do
    transfer = BankWeb.Transfer.changeset(%BankWeb.Transfer{}, transfer_params)

    if transfer.valid? do
      transfer = Ecto.Changeset.apply_changes(transfer)
      source = conn.assigns.current_customer.wallet
      destination = BankWeb.Repo.get!(BankWeb.Account, transfer.destination_account_id)

      {:ok, _} =
        BankWeb.Transfer.build(source, destination, "Transfer", transfer.amount_cents)
        |> BankWeb.Repo.transaction

      redirect conn, to: account_path(conn, :show)
    else
      transfer = %{transfer | action: :transfer}
      render conn, "new.html", transfer: transfer
    end
  end
end
