defmodule Bank.Transaction do
  use Bank.Model

  schema "transactions" do
    field :type, :string
    field :description, :string
    field :amount, Money.Ecto
    belongs_to :account, Account

    timestamps()
  end

  def from_tuple({type, %Account{} = account, description, %Money{} = amount})
      when type in [:credit, :debit] and is_binary(description) do

    %Transaction{
      type: Atom.to_string(type),
      account: account,
      description: description,
      amount: amount,
    }
  end
end
