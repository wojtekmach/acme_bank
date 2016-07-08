defmodule Messenger do
  @moduledoc ~S"""
  Messenger sends messages.

  For now only `Messenger.Test` adapter is available.
  """

  @type username :: String.t
  @type subject  :: String.t
  @type body     :: String.t

  @callback send(username, subject, body) :: :ok

  @impl Application.get_env(:messenger, :adapter)

  defdelegate send(username, subject, body), to: @impl
end
