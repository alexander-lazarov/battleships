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

  def end_game(game_id) do
    case GenServer.call(__MODULE__, {:end_game, game_id}) do
      :ok ->
        BattleshipsWeb.Endpoint.broadcast(
          "game:#{game_id}",
          "gameEnd",
          %{}
        )

        :ok

      error ->
        error
    end
  end

  def user_in_game?(user_id, game_id) do
    GenServer.call(__MODULE__, {:user_in_game?, user_id, game_id})
  end

  def handle_call({:start_game, user1, user2}, _from, state) do
    game_id = new_id()

    {:ok, game_server} = Battleships.GamesSupervisor.start_child(user1, user2)

    Task.async(fn ->
      Process.sleep(4000)

      __MODULE__.end_game(game_id)
    end)

    {:reply, game_id, state |> Map.put(game_id, game_server)}
  end

  def handle_call({:end_game, game_id}, _from, state) do
    case state |> Map.has_key?(game_id) do
      true ->
        case Battleships.GamesSupervisor.stop_child(state[game_id]) do
          :ok -> {:reply, :ok, state |> Map.delete(game_id)}
          _ -> :error
        end

      false ->
        {:reply, :error, state}
    end
  end

  def handle_call({:user_in_game?, user_id, game_id}, _from, state) do
    result =
      case state |> Map.has_key?(game_id) do
        true ->
          Battleships.GameServer.user_in_game?(state[game_id], user_id)

        false ->
          false
      end

    {:reply, result, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp new_id(), do: "#{Enum.random(1..100)}"
end
