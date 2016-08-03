defmodule Auth.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auth_accounts" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def build(params) do
    cast(%Auth.Account{}, params, ~w(email password))
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/.*@.*/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
  end
end
