defmodule Messenger do
  @moduledoc ~S"""
  Messenger delivers messages.

  Available adapters:

  - `Messenger.Logger`
  - `Messenger.Test`
  """

  @type email    :: String.t
  @type subject  :: String.t
  @type body     :: String.t

  @callback deliver_email(email, subject, body) :: :ok

  def deliver_email(email, subject, body) do
    adapter.deliver_email(email, subject, body)
  end

  defp adapter do
    Application.get_env(:messenger, :adapter)
  end
end
