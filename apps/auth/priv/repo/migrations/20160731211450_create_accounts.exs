defmodule Auth.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:auth_accounts) do
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:auth_accounts, [:email])
  end
end
