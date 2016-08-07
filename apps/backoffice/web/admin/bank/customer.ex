defmodule Backoffice.ExAdmin.Bank.Customer do
  use ExAdmin.Register

  register_resource Bank.Customer do
    menu label: "Bank Customers"
  end
end
