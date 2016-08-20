defmodule Messenger.Local do
  @moduledoc ~S"""
  Test adapter for `Messenger`.

  Stores messages on the filesystem. Run `setup/0` before each test to
  ensure clean state.
  """

  @root "tmp/messenger"

  def setup do
    File.rm_rf!(@root)
    :ok
  end

  def deliver_email(username, subject, body) do
    File.mkdir_p!(@root)

    uniq_id = :erlang.unique_integer()
    File.write!("#{@root}/#{username}-#{uniq_id}", "#{subject}\n\n#{body}")
    :ok
  end

  def messages_for(username) do
    File.mkdir_p!(@root)

    Path.wildcard("#{@root}/#{username}-*")
    |> Enum.map(fn path ->
      File.read!(path)
      |> String.split("\n\n", parts: 2)
      |> List.to_tuple
    end)
  end

  def subjects_for(username) do
    messages_for(username)
    |> Enum.map(&elem(&1, 0))
  end
end
