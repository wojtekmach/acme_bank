defmodule BankWeb.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :customer_id, references(:customers, on_delete: :nothing)

      timestamps
    end
    create index(:accounts, [:customer_id])
    create index(:accounts, [:name], unique: true)
  end
end
