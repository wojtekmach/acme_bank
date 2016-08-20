defmodule MessengerTest do
  use ExUnit.Case
  doctest Messenger

  setup do
    :ok = Messenger.Local.setup()
    :ok
  end

  test "messenger" do
    :ok = Messenger.deliver_email("alice", "subject 1", "body 1")
    :ok = Messenger.deliver_email("alice", "subject 2", "body 2")
    :ok = Messenger.deliver_email("bob", "subject 3", "body 3")
    
    assert Messenger.Local.subjects_for("alice") == ["subject 2", "subject 1"]
    assert Messenger.Local.messages_for("alice") == [
      {"subject 2", "body 2"},
      {"subject 1", "body 1"},
    ]

    assert Messenger.Local.subjects_for("bob") == ["subject 3"]
    assert Messenger.Local.messages_for("bob") == [
      {"subject 3", "body 3"},
    ]
  end
end
