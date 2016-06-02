defmodule BankWeb.Transfer do
  use BankWeb.Web, :model

  embedded_schema do
    field :amount_cents, :integer
    field :destination_account_id, :integer
  end

  def changeset(customer, struct, params \\ %{}) do
    struct
    |> cast(params, [:amount_cents, :destination_account_id])
    |> validate_required([:amount_cents, :destination_account_id])
    |> validate_number(:amount_cents, greater_than: 0)
    |> validate_destination_account(customer)
  end

  defp validate_destination_account(changeset, customer) do
    account_id = customer.wallet.id
    validate_change(changeset, :destination_account_id, fn
      field, ^account_id ->
        [{field, {"cannot transfer to the same account", []}}]
      _, _ ->
        []
    end)
  end

  def build(source, destination, description, amount_cents) do
    import BankWeb.Transaction, only: [credit: 3, debit: 3]

    Ecto.Multi.new
    |> Ecto.Multi.insert(:debit, debit(source, description, amount_cents))
    |> Ecto.Multi.insert(:credit, credit(destination, description, amount_cents))
  end

  def create(customer, params) do
    changeset = changeset(customer, %BankWeb.Transfer{}, params)

    if changeset.valid? do
      transfer = apply_changes(changeset)
      source = customer.wallet
      destination = BankWeb.Repo.get!(BankWeb.Account, transfer.destination_account_id)
      transactions = build(source, destination, "Transfer", transfer.amount_cents)

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
end
