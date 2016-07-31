defmodule Messenger do
  @moduledoc ~S"""
  Messenger delivers messages.

  For now only `Messenger.Test` adapter is available.
  """

  @type email    :: String.t
  @type subject  :: String.t
  @type body     :: String.t

  @callback deliver_email(email, subject, body) :: :ok

  @impl Application.get_env(:messenger, :adapter)

  defdelegate deliver_email(email, subject, body), to: @impl
end
