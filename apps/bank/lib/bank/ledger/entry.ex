defmodule Bank.Ledger.Entry do
  use Bank.Model

  @entry_types [:credit, :debit]

  schema "bank_entries" do
    field :type, :string
    field :description, :string
    field :amount, Money.Ecto
    belongs_to :account, Ledger.Account

    timestamps()
  end

  def from_tuple({type, %Ledger.Account{} = account, description, %Money{} = amount})
      when type in @entry_types and is_binary(description) do

    %Ledger.Entry{
      type: Atom.to_string(type),
      account: account,
      description: description,
      amount: amount,
    }
  end
end
