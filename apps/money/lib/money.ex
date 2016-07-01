defmodule Money do
  @moduledoc ~S"""
  Money represents some monetary value (stored in cents) in a given currency.

  ## Examples

      iex> Money.new("10.00 USD").currency
      "USD"
      iex> Money.new("10.00 USD").cents
      1000

      iex> Money.add(Money.new("10 USD"), Money.new("20 USD"))
      Money.new("30.00 USD")

      iex> "You owe me #{Money.new("10 USD")}"
      "You owe me $10.00"

      iex> inspect(Money.new("10 USD"))
      "Money.new(\"10.00 USD\")"

  """

  defstruct cents: 0, currency: nil

  def new(str) when is_binary(str) do
    [value, currency] = String.split(str, " ")

    {dollars, cents} =
      case String.split(value, ".") do
        [dollars, cents] -> {dollars, cents}
        [dollars] -> {dollars, "0"}
      end

    cents = String.to_integer(dollars) * 100 + String.to_integer(cents)
    %Money{cents: cents, currency: currency}
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
end

defimpl Inspect, for: Money do
  def inspect(%Money{currency: currency} = money, _opts) do
    <<_>> <> value = "#{money}"
    "Money.new(\"#{value} #{currency}\")"
  end
end

defimpl String.Chars, for: Money do
  def to_string(money) do
    Money.to_string(money)
  end
end
