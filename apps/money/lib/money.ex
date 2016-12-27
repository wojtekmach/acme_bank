defmodule Money do
  @moduledoc ~S"""
  `Money` represents some monetary value (stored in cents) in a given currency.

  See `Money.Ecto` for a custom type implementation that can be used in schemas.
  
  In order to use the `~M` sigil, import the module:
  
      import Money

  ## Examples

      iex> Money.new("10.00 USD")
      ~M"10.00 USD"

      iex> ~M"10.00 USD".currency
      "USD"
      iex> ~M"10.01 USD".cents
      1001

      iex> Money.add(~M"10 USD", ~M"20 USD")
      ~M"30.00 USD"

      iex> Kernel.to_string(~M"-10.50 USD")
      "-10.50 USD"

      iex> inspect(~M"10 USD")
      "~M\"10.00 USD\""

      iex> Money.parse("10 USD")
      {:ok, ~M"10 USD"}
      iex> Money.parse("10.1 USD")
      :error

      iex> ~M"10.001 USD"
      ** (ArgumentError) invalid string: "10.001 USD"

  """

  defstruct cents: 0, currency: nil

  def new(str) when is_binary(str) do
    case parse(str) do
      {:ok, money} -> money
      :error -> raise ArgumentError, "invalid string: #{inspect str}"
    end
  end

  def parse(str) when is_binary(str) do
    case Regex.run(~r/\A(-?)(\d+)(\.(\d{2}))?\ ([A-Z]{3})\z/, str) do
      [_, sign, dollars, _, cents, currency] ->
        do_parse(sign, dollars, cents, currency)
      _ -> :error
    end
  end

  defp do_parse(sign, dollars, "", currency),
    do: do_parse(sign, dollars, "00", currency)
  defp do_parse(sign, dollars, cents, currency) do
    sign = if sign == "-", do: -1, else: 1
    cents = sign * (String.to_integer(dollars) * 100 + String.to_integer(cents))
    {:ok, %Money{cents: cents, currency: currency}}
  end

  def sigil_M(str, _opts),
    do: new(str)

  def add(%Money{cents: left_cents, currency: currency},
          %Money{cents: right_cents, currency: currency}) do
    %Money{cents: left_cents + right_cents, currency: currency}
  end

  def to_string(%Money{cents: cents, currency: currency}) when cents >= 0 do
    {dollars, cents} = {div(cents, 100), rem(cents, 100)}
    cents = :io_lib.format("~2..0B", [cents]) |> IO.iodata_to_binary
    "#{dollars}.#{cents} #{currency}"
  end
  def to_string(%Money{cents: cents, currency: currency}) do
    "-" <> Money.to_string(%Money{cents: -cents, currency: currency})
  end
end

defimpl Inspect, for: Money do
  def inspect(money, _opts),
    do: "~M\"#{money}\""
end

defimpl String.Chars, for: Money do
  defdelegate to_string(data), to: Money
end
