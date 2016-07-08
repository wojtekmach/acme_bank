defmodule MessengerTest do
  use ExUnit.Case
  doctest Messenger

  setup do
    :ok = Messenger.Test.setup()
    :ok
  end

  test "messenger" do
    :ok = Messenger.send("alice", "subject 1", "body 1")
    :ok = Messenger.send("alice", "subject 2", "body 2")
    :ok = Messenger.send("bob", "subject 3", "body 3")
    
    assert Messenger.Test.subjects_for("alice") == ["subject 2", "subject 1"]
    assert Messenger.Test.messages_for("alice") == [
      {"subject 2", "body 2"},
      {"subject 1", "body 1"},
    ]

    assert Messenger.Test.subjects_for("bob") == ["subject 3"]
    assert Messenger.Test.messages_for("bob") == [
      {"subject 3", "body 3"},
    ]
  end
end
