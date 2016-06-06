defmodule BankWeb.Repo do
  use Ecto.Repo, otp_app: :bank_web

  @isolation_levels [:serializable]

  def transaction_isolation(level) when level in @isolation_levels do
    {:ok, _} = Ecto.Adapters.SQL.query(
       BankWeb.Repo,
       "SET TRANSACTION ISOLATION LEVEL #{level}",
       [])
    :ok
  end

  def multi_transaction_with_isolation(multi, level) do
    result =
      transaction(fn ->
        transaction_isolation(level)

        case transaction(multi) do
          {:ok, _} = result ->
            result
          {:error, a, b, c} ->
            rollback({a, b, c})
        end
      end)

    case result do
      {:ok, _} = result -> result
      {:error, {a, b, c}} -> {:error, a, b, c}
    end
  end
end
