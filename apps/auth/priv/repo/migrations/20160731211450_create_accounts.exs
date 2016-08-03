defmodule Auth.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts) do
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:bank_accounts, [:email])
  end
end
