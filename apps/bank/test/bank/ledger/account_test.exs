defmodule Bank.Ledger.AccountTest do
  use Bank.Case
  alias Bank.Ledger.Account

  @valid_attrs %{type: "liability", name: "some content", currency: "USD"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
