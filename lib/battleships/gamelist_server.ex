defmodule Battleships.GamelistServer do
  use GenServer

  def init(_), do: {:ok, %{}}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_game(user1, user2) do
    game_id = GenServer.call(__MODULE__, {:start_game, user1, user2})

    BattleshipsWeb.Endpoint.broadcast(
      "userlist:#{user2}",
      "gameStart",
      %{game_id: game_id}
    )

    BattleshipsWeb.Endpoint.broadcast(
      "userlist:#{user1}",
      "gameStart",
      %{game_id: game_id}
    )

    game_id
  end

  def handle_call({:start_game, user1, user2}, _from, state) do
    game_id = new_id()
    game_server = Battleships.GamesSupervisor.start_child(user1, user2)

    {:reply, game_id, state |> Map.put(game_id, game_server)}
  end

  defp new_id(), do: Enum.random(1..100)
end
