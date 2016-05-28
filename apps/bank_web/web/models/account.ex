defmodule BankWeb.Account do
  use BankWeb.Web, :model

  schema "accounts" do
    field :name, :string
    belongs_to :customer, BankWeb.Customer

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def balance(%BankWeb.Account{}) do
    0
  end
end
