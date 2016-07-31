defmodule AuthTest do
  use ExUnit.Case

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo, [])
    :ok
  end

  test "register: success" do
    assert {:ok, alice} = Auth.register(%{email: "alice@example.com", password: "secret12"})

    assert alice.email == "alice@example.com"
    assert Comeonin.Bcrypt.checkpw("secret12", alice.password_hash)
  end

  test "register: failure" do
    {:ok, _}    = Auth.register(%{email: "alice@example.com", password: "secret12"})
    {:error, _} = Auth.register(%{email: "alice@example.com", password: "secret12"})
    {:error, _} = Auth.register(%{email: "bob@example.com", password: ""})
  end

  test "sign in" do
    {:ok, alice} = Auth.register(%{email: "alice@example.com", password: "secret12"})
    id = alice.id

    assert {:ok, %{id: ^id}} = Auth.sign_in("alice@example.com", "secret12")
    assert {:error, :unauthorized} = Auth.sign_in("alice@example.com", "bad")
    assert {:error, :not_found} = Auth.sign_in("bad@example.com", "bad")
  end
end
