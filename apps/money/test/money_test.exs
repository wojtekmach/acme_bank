defmodule MoneyTest do
  use ExUnit.Case
  doctest Money, import: true
  import Money, only: [sigil_M: 2]

  test "works" do
    assert ~M"10 USD"    == %Money{cents: 10_00, currency: "USD"}
    assert ~M"10.00 USD" == %Money{cents: 10_00, currency: "USD"}
    assert ~M"-5.10 USD" == %Money{cents: -5_10, currency: "USD"}

    assert to_string(~M"10 USD")    == "10.00 USD"
    assert to_string(~M"10.00 USD") == "10.00 USD"
    assert to_string(~M"-5.10 USD") == "-5.10 USD"
  end
end
