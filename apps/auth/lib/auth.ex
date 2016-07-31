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

  def sign_in(email, password) do
    account = Repo.get_by(Account, email: email)
    do_sign_in(account, password)
  end

  defp do_sign_in(%Account{password_hash: password_hash} = account, password) do
    if Comeonin.Bcrypt.checkpw(password, password_hash) do
      {:ok, account}
    else
      {:error, :unauthorized}
    end
  end
  defp do_sign_in(nil, _) do
    Comeonin.Bcrypt.dummy_checkpw()
    {:error, :not_found}
  end
end
