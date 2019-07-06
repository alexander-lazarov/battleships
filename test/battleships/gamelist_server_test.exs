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

  test "can test if user is in game" do
    Battleships.UserlistServer.join("id1", "user1")
    Battleships.UserlistServer.join("id2", "user2")

    game_id = Battleships.GamelistServer.start_game("id1", "id2")

    assert Battleships.GamelistServer.user_in_game?("id1", game_id) == true
    assert Battleships.GamelistServer.user_in_game?("id2", game_id) == true
    assert Battleships.GamelistServer.user_in_game?("id3", game_id) == false
    assert Battleships.GamelistServer.user_in_game?("id1", game_id + 1) == false
  end
end
