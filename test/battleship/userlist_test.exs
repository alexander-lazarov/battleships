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
end
