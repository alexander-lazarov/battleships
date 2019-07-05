defmodule Battleship.UserlistTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, _} = Application.ensure_all_started(:battleships)

    on_exit(fn ->
      Application.stop(:battleships)
    end)

    :ok
  end

  test "the list is empty initially" do
    assert Battleships.Userlist.get() == []
  end

  test "that a user can join" do
    assert :ok == Battleships.Userlist.join("id1", "user1")
    assert Battleships.Userlist.get() |> Enum.map(& &1.name) == ["user1"]
  end

  test "that the same username cannot join twice" do
    assert :ok == Battleships.Userlist.join("id1", "user1")
    assert :username_in_use == Battleships.Userlist.join("id2", "user1")
    assert Battleships.Userlist.get() |> Enum.map(& &1.name) == ["user1"]
  end

  test "that the same socket_id cannot join twice" do
    assert :ok == Battleships.Userlist.join("id1", "user1")
    assert :socket_id_in_use == Battleships.Userlist.join("id1", "user2")
    assert Battleships.Userlist.get() |> Enum.map(& &1.name) == ["user1"]
  end

  test "id_exists?/1" do
    assert !Battleships.Userlist.id_exists?("id1")
    Battleships.Userlist.join("id1", "user1")
    assert Battleships.Userlist.id_exists?("id1")

    Battleships.Userlist.leave("id1")
    assert !Battleships.Userlist.id_exists?("id1")
  end

  test "that users can leave" do
    Battleships.Userlist.join("id1", "user1")
    assert Battleships.Userlist.leave("id1") == :ok
    assert Battleships.Userlist.get() == []
  end

  test "that a user won't be able to leave twice" do
    Battleships.Userlist.join("id1", "user1")
    assert Battleships.Userlist.leave("id1") == :ok
    assert Battleships.Userlist.leave("id1") == :unknown_socket_id

    assert Battleships.Userlist.get() == []
  end
end
