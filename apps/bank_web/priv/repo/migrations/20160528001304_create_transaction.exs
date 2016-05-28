defmodule BankWeb.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :type, :string
      add :description, :string
      add :amount_cents, :integer
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps
    end
    create index(:transactions, [:account_id])
  end
end
