defmodule BankWeb.AccountView do
  use BankWeb.Web, :view

  def format_amount(%Bank.Ledger.Entry{type: type, amount: amount}) do
    sign(type) <> format_money(amount)
  end

  defp sign("credit"), do: "+"
  defp sign("debit"), do: "-"

  def format_money(%Money{} = money) do
    [value, currency] = to_string(money) |> String.split(" ", trim: true)
    do_format_money(value, currency)
  end

  defp do_format_money(value, "USD"), do: "$" <> value
end
