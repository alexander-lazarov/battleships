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

  test "that you can insert users" do
    assert :ok == Battleships.Userlist.add("user1")
    assert Battleships.Userlist.get() == ["user1"]
  end

  test "that you cannot insert the same user twice" do
    assert :ok == Battleships.Userlist.add("user1")
    assert :in_use == Battleships.Userlist.add("user1")
    assert Battleships.Userlist.get() == ["user1"]
  end
end
