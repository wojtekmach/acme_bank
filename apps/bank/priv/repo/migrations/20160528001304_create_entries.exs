defmodule Bank.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    execute """
    CREATE TYPE moneyz AS (
      cents integer,
      currency varchar
    );
    """

    create table(:bank_entries) do
      add :type, :string
      add :description, :string
      add :amount, :moneyz
      add :account_id, references(:bank_accounts, on_delete: :nothing)

      timestamps()
    end
    create index(:bank_entries, [:account_id])
  end
end
