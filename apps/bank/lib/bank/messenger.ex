defmodule Bank.Messenger do
  @type username :: String.t
  @type subject  :: String.t
  @type body     :: String.t

  @callback send(username, subject, body) :: :ok

  @impl Application.get_env(:bank, :messenger)

  defdelegate send(username, subject, body), to: @impl
end

defmodule Bank.Messenger.Test do
  @root "tmp/messenger"

  def setup do
    File.rm_rf!(@root)
    File.mkdir_p!(@root)
    :ok
  end

  def send(username, subject, body) do
    uniq_id = :erlang.unique_integer()
    File.write!("#{@root}/#{username}-#{uniq_id}", "#{subject}\n\n#{body}")
    :ok
  end

  def messages_for(username) do
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
