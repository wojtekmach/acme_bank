defmodule BankWeb.Account do
  use BankWeb.Web, :model

  schema "accounts" do
    field :type, :string
    field :name, :string
    belongs_to :customer, BankWeb.Customer

    timestamps
  end

  def build_asset(name) do
    changeset(%BankWeb.Account{}, Map.put(%{type: "asset"}, :name, name))
  end

  def build_wallet(name) do
    changeset(%BankWeb.Account{}, Map.put(%{type: "liability"}, :name, name))
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :name])
    |> validate_required([:type, :name])
    |> unique_constraint(:name)
    |> validate_inclusion(:type, ~w(asset liability))
  end
end
