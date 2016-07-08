defmodule BankWeb.Customer do
  use BankWeb.Web, :model

  schema "customers" do
    field :username, :string

    has_one :wallet, Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(username)a)
    |> validate_required(~w(username)a)
    |> unique_constraint(:username)
  end

  def build(%{username: username}) do
    changeset(%Customer{}, %{username: username})
    |> put_assoc(:wallet, Account.build_wallet("Wallet: #{username}"))
  end
end
