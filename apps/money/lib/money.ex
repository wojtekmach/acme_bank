defmodule Money do
  @moduledoc ~S"""
  Money represents some monetary value (stored in cents) in a given currency.

  ## Examples

      iex> ~M"10.00 USD".currency
      "USD"
      iex> ~M"10.01 USD".cents
      1001

      iex> Money.add(~M"10 USD", ~M"20 USD")
      ~M"30.00 USD"

      iex> "You owe me #{~M"10 USD"}"
      "You owe me $10.00"

      iex> inspect(~M"10 USD")
      "~M\"10.00 USD\""

  """

  defstruct cents: 0, currency: nil

  def new(str) when is_binary(str) do
    # TODO: make sure we don't allow:
    #       - 10.001 USD
    #       - 10.00 USDO
    [value, currency] = String.split(str, " ")

    {dollars, cents} =
      case String.split(value, ".") do
        [dollars, cents] -> {dollars, cents}
        [dollars] -> {dollars, "0"}
      end

    cents = String.to_integer(dollars) * 100 + String.to_integer(cents)
    %Money{cents: cents, currency: currency}
  end

  def sigil_M(str, _opts) do
    new(str)
  end

  def add(%Money{cents: left_cents, currency: currency},
          %Money{cents: right_cents, currency: currency}) do
    %Money{cents: left_cents + right_cents, currency: currency}
  end

  def to_string(%Money{cents: cents, currency: "USD"}) do
    {dollars, cents} = {div(cents, 100), rem(cents, 100)}
    cents = :io_lib.format("~2..0B", [cents]) |> IO.iodata_to_binary
    "$#{dollars}.#{cents}"
  end

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

defimpl Inspect, for: Money do
  def inspect(%Money{currency: "USD"} = money, _opts) do
    "$" <> value = "#{money}"
    "~M\"#{value} USD\""
  end
end

defimpl String.Chars, for: Money do
  defdelegate to_string(data), to: Money
end

if Code.ensure_loaded?(Phoenix.HTML.Safe) do
  defimpl Phoenix.HTML.Safe, for: Money do
    defdelegate to_iodata(data), to: Money, as: :to_string
  end
end
