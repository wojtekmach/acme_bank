defmodule AuthTest do
  use ExUnit.Case

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo, [])
    :ok
  end

  test "register: success" do
    assert {:ok, account} = Auth.register(%{email: "alice@example.com", password: "secret12"})

    assert account.email == "alice@example.com"
    assert Comeonin.Bcrypt.checkpw("secret12", account.password_hash)
  end

  test "register: failure" do
    {:ok, _}    = Auth.register(%{email: "alice@example.com", password: "secret12"})
    {:error, _} = Auth.register(%{email: "alice@example.com", password: "secret12"})
    {:error, _} = Auth.register(%{email: "bob@example.com", password: ""})
  end
end
