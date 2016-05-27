defmodule BankWeb.AccountView do
  use BankWeb.Web, :view

  @doc ~S"""
  ## Examples

      iex> BankWeb.AccountView.format_money(0)
      "$0.00"
      iex> BankWeb.AccountView.format_money(1_00)
      "$1.00"
      iex> BankWeb.AccountView.format_money(1_01)
      "$1.01"
      iex> BankWeb.AccountView.format_money(1_10)
      "$1.10"

  """
  def format_money(amount_cents) when is_integer(amount_cents) and amount_cents >= 0 do
    dollars = div(amount_cents, 100)
    cents = rem(amount_cents, 100)
    "$#{dollars}.#{format_cents(cents)}"
  end
  defp format_cents(cents) when cents < 10, do: "0#{cents}"
  defp format_cents(cents), do: cents
end
