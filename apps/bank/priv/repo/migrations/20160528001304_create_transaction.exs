defmodule Bank.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    execute """
    CREATE TYPE moneyz AS (
      cents integer,
      currency varchar
    );
    """

    create table(:transactions) do
      add :type, :string
      add :description, :string
      add :amount, :moneyz
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end
    create index(:transactions, [:account_id])
  end
end
