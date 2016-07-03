if Code.ensure_loaded?(Phoenix.HTML.Safe) do
  defimpl Phoenix.HTML.Safe, for: Money do
    defdelegate to_iodata(data), to: Money, as: :to_string
  end
end
