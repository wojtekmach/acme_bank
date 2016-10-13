defmodule Bank.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Bank.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Bank.Case

      import Money, only: [sigil_M: 2]
      use Bank.Model
    end
  end

  setup tags do
    opts = tags |> Map.take([:isolation]) |> Enum.to_list()
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Bank.Repo, opts)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo, opts)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Auth.Repo, {:shared, self()})
      Ecto.Adapters.SQL.Sandbox.mode(Bank.Repo, {:shared, self()})
    end

    :ok
  end
end
