defmodule Bank.IExHelpers do
  def alice do
    Bank.find_customer!(username: "alice")
  end

  def bob do
    Bank.find_customer!(username: "bob")
  end
end
