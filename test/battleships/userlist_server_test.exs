defmodule Battleship.UserlistServerTest do
  use ExUnit.Case

  setup do
    {:ok, _} = Application.ensure_all_started(:battleships)

    on_exit(fn ->
      Application.stop(:battleships)
    end)

    :ok
  end

  test "the list is empty initially" do
    assert Battleships.UserlistServer.get() == []
  end

  test "that a user can join" do
    assert :ok == Battleships.UserlistServer.join("id1", "user1")
    assert Battleships.UserlistServer.get() |> Enum.map(& &1.name) == ["user1"]
  end

  test "that the same username cannot join twice" do
    assert :ok == Battleships.UserlistServer.join("id1", "user1")
    assert :username_in_use == Battleships.UserlistServer.join("id2", "user1")
    assert Battleships.UserlistServer.get() |> Enum.map(& &1.name) == ["user1"]
  end

  test "that the same socket_id cannot join twice" do
    assert :ok == Battleships.UserlistServer.join("id1", "user1")
    assert :socket_id_in_use == Battleships.UserlistServer.join("id1", "user2")
    assert Battleships.UserlistServer.get() |> Enum.map(& &1.name) == ["user1"]
  end

  test "id_exists?/1" do
    assert !Battleships.UserlistServer.id_exists?("id1")
    Battleships.UserlistServer.join("id1", "user1")
    assert Battleships.UserlistServer.id_exists?("id1")

    Battleships.UserlistServer.leave("id1")
    assert !Battleships.UserlistServer.id_exists?("id1")
  end

  test "that users can leave" do
    Battleships.UserlistServer.join("id1", "user1")
    assert Battleships.UserlistServer.leave("id1") == :ok
    assert Battleships.UserlistServer.get() == []
  end

  test "that a user won't be able to leave twice" do
    Battleships.UserlistServer.join("id1", "user1")
    assert Battleships.UserlistServer.leave("id1") == :ok
    assert Battleships.UserlistServer.leave("id1") == :unknown_socket_id

    assert Battleships.UserlistServer.get() == []
  end
end
