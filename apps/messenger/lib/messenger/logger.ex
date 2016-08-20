defmodule Messenger.Logger do
  require Logger

  def deliver_email(email, subject, body) do
    Logger.info("Delivered email:#{inspect email} subject:#{inspect subject} body:#{inspect body}")
    :ok
  end
end
