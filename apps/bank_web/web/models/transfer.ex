defmodule BankWeb.Transfer do
  use BankWeb.Web, :model

  embedded_schema do
    field :amount_cents, :integer
    field :destination_username, :string

    embeds_one :destination_customer, BankWeb.Customer
  end

  def changeset(customer, struct, params \\ %{}) do
    struct
    |> cast(params, [:amount_cents, :destination_username])
    |> validate_required([:amount_cents, :destination_username])
    |> validate_number(:amount_cents, greater_than: 0)
    |> validate_destination(customer)
  end

  defp validate_destination(changeset, customer) do
    source_username = customer.username
    destination_username = get_change(changeset, :destination_username)

    cond do
      source_username == destination_username ->
        add_error(changeset, :destination_username, "cannot transfer to the same account")
      !destination_username ->
        changeset
      true ->
        q = from c in BankWeb.Customer, where: c.username == ^destination_username, preload: :wallet
        destination = BankWeb.Repo.one(q)

        if destination do
          put_embed(changeset, :destination_customer, destination)
        else
          add_error(changeset, :destination_username, "is invalid")
        end
    end
  end

  def create(customer, params) do
    changeset = changeset(customer, %BankWeb.Transfer{}, params)

    if changeset.valid? do
      transfer = apply_changes(changeset)
      source_account = customer.wallet
      destination_account = transfer.destination_customer.wallet
      transactions = build(source_account, destination_account, "Transfer", transfer.amount_cents)

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
