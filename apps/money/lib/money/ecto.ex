if Code.ensure_loaded?(Ecto.Type) do
  defmodule Money.Ecto do
    @behaviour Ecto.Type

    def type, do: :moneyz

    # TODO:
    def cast(_), do: :error

    def load({cents, currency}) when is_integer(cents) and is_binary(currency) do
      {:ok, %Money{cents: cents, currency: currency}}
    end
    def load(_), do: :error

    def dump(%Money{cents: cents, currency: currency}) do
      {:ok, {cents, currency}}
    end
    def dump(_), do: :error
  end
end
