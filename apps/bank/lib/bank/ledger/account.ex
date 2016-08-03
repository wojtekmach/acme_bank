defmodule Bank.Ledger.Account do
  use Bank.Model

  @account_types ~w(asset liability)

  schema "bank_accounts" do
    field :type, :string
    field :name, :string
    field :currency, :string

    timestamps()
  end

  def build_asset(name) do
    changeset(%Ledger.Account{}, Map.put(%{type: "asset", currency: "USD"}, :name, name))
  end

  def build_wallet(name) do
    changeset(%Ledger.Account{}, Map.put(%{type: "liability", currency: "USD"}, :name, name))
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :name, :currency])
    |> validate_required([:type, :name, :currency])
    |> unique_constraint(:name)
    |> validate_inclusion(:type, @account_types)
  end
end
