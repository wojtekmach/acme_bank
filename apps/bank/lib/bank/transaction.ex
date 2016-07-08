defmodule Bank.Transaction do
  use Bank.Model

  schema "transactions" do
    field :type, :string
    field :description, :string
    field :amount, Money.Ecto
    belongs_to :account, Account

    timestamps()
  end

  def credit(account, description, amount_cents) do
    transaction("credit", account, description, amount_cents)
  end

  def debit(account, description, amount_cents) do
    transaction("debit", account, description, amount_cents)
  end

  defp transaction(type, account, description, amount_cents) do
    %Transaction{
      type: type,
      account: account,
      description: description,
      amount: amount_cents,
    }
  end
end
