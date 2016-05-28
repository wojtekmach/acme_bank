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

  def balance(%BankWeb.Account{id: id}) do
    from(t in BankWeb.Transaction,
         select: fragment("SUM(CASE WHEN t0.type = 'credit' THEN t0.amount_cents ELSE -t0.amount_cents END)"),
         where: t.account_id == ^id)
    |> BankWeb.Repo.one || 0
  end

  def deposits_account do
    BankWeb.Repo.get_by(BankWeb.Account, name: "Deposits") ||
      BankWeb.Repo.insert!(%BankWeb.Account{name: "Deposits"})
  end
end
