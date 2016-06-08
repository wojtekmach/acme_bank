defmodule BankWeb.Transfer do
  use BankWeb.Web, :model

  embedded_schema do
    field :amount_cents, :integer
    field :destination_account_id, :integer

    embeds_one :destination_account, BankWeb.Account
  end

  def changeset(customer, struct, params \\ %{}) do
    struct
    |> cast(params, [:amount_cents, :destination_account_id])
    |> validate_required([:amount_cents, :destination_account_id])
    |> validate_number(:amount_cents, greater_than: 0)
    |> validate_destination_account(customer)
  end

  defp validate_destination_account(changeset, customer) do
    source_account_id = customer.wallet.id
    destination_account_id = get_change(changeset, :destination_account_id)

    if source_account_id == destination_account_id do
      add_error(changeset, :destination_account_id, "cannot transfer to the same account")
    else
      destination = BankWeb.Repo.get_by(BankWeb.Account, id: destination_account_id)
      if destination do
        put_embed(changeset, :destination_account, destination)
      else
        add_error(changeset, :destination_account_id, "is invalid")
      end
    end
  end

  def create(customer, params) do
    changeset = changeset(customer, %BankWeb.Transfer{}, params)

    if changeset.valid? do
      transfer = apply_changes(changeset)
      source_account = customer.wallet
      transactions = build(source_account, transfer.destination_account, "Transfer", transfer.amount_cents)

      case BankWeb.Ledger.write(transactions) do
        {:ok, _} ->
          :ok
        {:error, :sufficient_funds, _, _} ->
          changeset = add_error(changeset, :amount_cents, "insufficient funds")
          {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  defp build(source, destination, description, amount_cents) do
    import BankWeb.Transaction, only: [credit: 3, debit: 3]

    Ecto.Multi.new
    |> Ecto.Multi.insert(:debit, debit(source, description, amount_cents))
    |> Ecto.Multi.insert(:credit, credit(destination, description, amount_cents))
  end
end
