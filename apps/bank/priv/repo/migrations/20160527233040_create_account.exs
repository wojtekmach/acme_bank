defmodule Bank.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :type, :string, null: false
      add :name, :string, null: false
      add :currency, :string, null: false

      timestamps()
    end
    create index(:accounts, [:name], unique: true)
  end
end
