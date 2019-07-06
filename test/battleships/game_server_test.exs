defmodule Battleships.GameServerTest do
  use ExUnit.Case

  setup do
    {:ok, _} = Application.ensure_all_started(:battleships)

    on_exit(fn ->
      Application.stop(:battleships)
    end)

    :ok
  end

  test "user_in_game? if " do
    {:ok, pid} = GenServer.start_link(Battleships.GameServer, ["id1", "id2"])

    assert Battleships.GameServer.user_in_game?(pid, "id1") == true
    assert Battleships.GameServer.user_in_game?(pid, "id2") == true
    assert Battleships.GameServer.user_in_game?(pid, "id3") == false
  end
end
