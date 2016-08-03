defmodule Bank.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:bank_accounts) do
      add :type, :string, null: false
      add :name, :string, null: false
      add :currency, :string, null: false

      timestamps()
    end
    create index(:bank_accounts, [:name], unique: true)
  end
end
