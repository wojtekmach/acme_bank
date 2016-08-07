defmodule Backoffice.ExAdmin.Bank.Ledger.Entry do
  use ExAdmin.Register

  register_resource Bank.Ledger.Entry do
    menu label: "Bank Entries"

    actions :all, only: [:index]
  end
end
