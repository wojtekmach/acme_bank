defmodule MasterProxy.Plug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
		cond do
      conn.request_path =~ ~r{/backoffice} ->
        Backoffice.Endpoint.call(conn, [])
      true ->
        BankWeb.Endpoint.call(conn, [])
    end
  end
end
