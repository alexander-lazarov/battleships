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
    assert :ok == Battleships.Userlist.join("user1")
    assert Battleships.Userlist.get() == ["user1"]
  end

  test "that the same user cannot join twice" do
    assert :ok == Battleships.Userlist.join("user1")
    assert :in_use == Battleships.Userlist.join("user1")
    assert Battleships.Userlist.get() == ["user1"]
  end

  test "that users can leave" do
    Battleships.Userlist.join("user1")
    assert Battleships.Userlist.leave("user1") == :ok
    assert Battleships.Userlist.get() == []
  end

  test "that a user won't be able to leave twice" do
    Battleships.Userlist.join("user1")
    assert Battleships.Userlist.leave("user1") == :ok
    assert Battleships.Userlist.leave("user1") == :unknown_user
    assert Battleships.Userlist.get() == []
  end
end
