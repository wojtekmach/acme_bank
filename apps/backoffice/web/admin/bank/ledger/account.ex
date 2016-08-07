defmodule Backoffice.ExAdmin.Bank.Ledger.Account do
  use ExAdmin.Register

  register_resource Bank.Ledger.Account do
    menu label: "Bank Accounts"

    index do
      column :id
      column :type
      column :name
      column :currency
      column :balance, fn account ->
        Bank.Ledger.balance(account) |> Money.to_string
      end
    end
  end
end
