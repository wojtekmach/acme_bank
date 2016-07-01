defmodule BankWeb.Transaction do
  use BankWeb.Web, :model

  schema "transactions" do
    field :type, :string
    field :description, :string
    field :amount, Money
    belongs_to :account, BankWeb.Account

    timestamps()
  end

  def credit(account, description, amount_cents) do
    transaction("credit", account, description, amount_cents)
  end

  def debit(account, description, amount_cents) do
    transaction("debit", account, description, amount_cents)
  end

  defp transaction(type, account, description, amount_cents) do
    %BankWeb.Transaction{
      type: type,
      account: account,
      description: description,
      amount: amount_cents,
    }
  end
end
