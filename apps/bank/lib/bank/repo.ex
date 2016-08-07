defmodule Bank.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :bank
  use Scrivener, page_size: 10

  def transaction_with_isolation(fun_or_multi, opts) do
    false = Bank.Repo.in_transaction?
    level = Keyword.fetch!(opts, :level)

    transaction(fn ->
      {:ok, _} = Ecto.Adapters.SQL.query(Bank.Repo, "SET TRANSACTION ISOLATION LEVEL #{level}", [])

      case transaction(fun_or_multi, opts) do
        {:ok, result} -> {:ok, result}
        {:error, reason} -> Bank.Repo.rollback(reason)
      end
      |> unwrap_transaction_result
    end, opts)
  end

  defp unwrap_transaction_result({:ok, result}), do: result
  defp unwrap_transaction_result(other), do: other
end
