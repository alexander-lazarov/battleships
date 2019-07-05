defmodule Battleships.GamelistServerTest do
  use ExUnit.Case

  setup do
    {:ok, _} = Application.ensure_all_started(:battleships)

    on_exit(fn ->
      Application.stop(:battleships)
    end)

    :ok
  end

  test "test can start a game" do
    Battleships.UserlistServer.join("id1", "user1")
    Battleships.UserlistServer.join("id2", "user2")

    assert Battleships.GamelistServer.start_game("id1", "id2")
  end

  test "can end a game" do
    Battleships.UserlistServer.join("id1", "user1")
    Battleships.UserlistServer.join("id2", "user2")

    game_id = Battleships.GamelistServer.start_game("id1", "id2")

    assert Battleships.GamelistServer.end_game(game_id) == :ok
  end

  test "cannot end a game that haven't started" do
    assert Battleships.GamelistServer.end_game("no-such-game-id") == :error
  end
end
