defmodule BankWeb.TransactionTest do
  use BankWeb.ModelCase

  alias BankWeb.Transaction

  @valid_attrs %{amount_cents: 42, description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
