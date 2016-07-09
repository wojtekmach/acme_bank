defmodule Bank.Transfer do
  use Bank.Model

  embedded_schema do
    field :amount_cents, :integer
    field :destination_username, :string

    embeds_one :source_customer, Customer
    embeds_one :destination_customer, Customer
  end

  def changeset(customer, struct, params \\ %{}) do
    struct
    |> cast(params, [:amount_cents, :destination_username])
    |> put_embed(:source_customer, customer)
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
        q = from c in Customer, where: c.username == ^destination_username, preload: :wallet
        destination = Repo.one(q)

        if destination do
          put_embed(changeset, :destination_customer, destination)
        else
          add_error(changeset, :destination_username, "is invalid")
        end
    end
  end

  def create(customer, params) do
    changeset = changeset(customer, %Transfer{}, params)

    if changeset.valid? do
      transfer = apply_changes(changeset)
      source_account = customer.wallet
      destination_account = transfer.destination_customer.wallet
      {:ok, _} = ensure_same_currencies(source_account, destination_account)

      amount = %Money{cents: transfer.amount_cents, currency: source_account.currency}
      transactions = build_transactions(source_account, destination_account, "Transfer", amount)

      case Ledger.write(transactions) do
        {:ok, _} ->
          {:ok, transfer}
        {:error, :insufficient_funds} ->
          changeset = add_error(changeset, :amount_cents, "insufficient funds")
          {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  defp build_transactions(source, destination, description, amount) do
    [
      {:debit, source, description, amount},
      {:credit, destination, description, amount},
    ]
  end

  defp ensure_same_currencies(%Account{currency: c}, %Account{currency: c}),
    do: {:ok, c}
  defp ensure_same_currencies(a, b),
    do: {:error, a.currency, b.currency}
end
