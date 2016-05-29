defmodule BankWeb.TransferControllerTest do
  use BankWeb.ConnCase

  setup do
    alice = BankWeb.Customer.build(%{username: "alice"}) |> BankWeb.Repo.insert!
    bob = BankWeb.Customer.build(%{username: "bob"}) |> BankWeb.Repo.insert!
    {:ok, _} = BankWeb.Deposit.build(alice, 10_00) |> BankWeb.Repo.transaction

    conn =
      build_conn()
      |> assign(:current_customer, alice)

    {:ok, %{conn: conn, alice: alice, bob: bob}}
  end

  test "create: success", %{conn: conn, alice: alice, bob: bob} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: 2_00, destination_account_id: bob.wallet.id}}
    assert html_response(conn, 302)
    assert BankWeb.Ledger.balance(alice.wallet) == 8_00
    assert BankWeb.Ledger.balance(bob.wallet) == 2_00
  end

  test "create: invalid amount", %{conn: conn} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: "bad"}}
    assert html_response(conn, 200) =~ "is invalid"
  end

  test "create: insufficient funds", %{conn: conn, alice: alice, bob: bob} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: 999_00, destination_account_id: bob.wallet.id}}
    assert html_response(conn, 200) =~ "insufficient funds"
    assert BankWeb.Ledger.balance(alice.wallet) == 10_00
    assert BankWeb.Ledger.balance(bob.wallet) == 0
  end

  test "create: cannot transfer to the same account", %{conn: conn, alice: alice} do
    conn = post conn, "/transfers", %{"transfer" => %{amount_cents: 2_00, destination_account_id: alice.wallet.id}}
    assert html_response(conn, 200) =~ "cannot transfer to the same account"
    assert BankWeb.Ledger.balance(alice.wallet) == 10_00
  end
end
