defmodule Battleships.GamelistServer do
  use GenServer

  def init(_), do: {:ok, []}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_game(user1, user2) do
    BattleshipsWeb.Endpoint.broadcast(
      "userlist:#{user2}",
      "gameStart",
      %{}
    )
  end

  defp new_id(), do: Enum.random(1.100)
end
