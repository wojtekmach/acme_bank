defmodule Auth do
  alias Auth.{Account, Repo}
  import Ecto.Changeset

  def register(params) do
    changeset = Account.build(params)

    if changeset.valid? do
      changeset
      |> put_password_hash()
      |> Repo.insert()
    else
      {:error, changeset}
    end
  end

  defp put_password_hash(%{changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end
end
