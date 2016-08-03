defmodule Bank.Repo.Migrations.CreateCustomer do
  use Ecto.Migration

  def change do
    create table(:bank_customers) do
      add :username, :string
      add :email, :string
      add :wallet_id, references(:bank_accounts, on_delete: :nothing)
      add :auth_account_id, :integer

      timestamps()
    end

    create index(:bank_customers, [:username], unique: true)
    create index(:bank_customers, [:email], unique: true)
  end
end
