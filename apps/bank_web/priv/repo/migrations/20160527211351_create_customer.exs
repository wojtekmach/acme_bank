defmodule BankWeb.Repo.Migrations.CreateCustomer do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :username, :string

      timestamps
    end

    create index(:customers, [:username], unique: true)
  end
end
