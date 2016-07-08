defmodule Bank.Model do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      alias Bank.{
        Account,
        Customer,
        Deposit,
        Ledger,
        Repo,
        Transfer,
        Transaction
      }
    end
  end
end
