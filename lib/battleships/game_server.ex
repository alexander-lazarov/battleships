defmodule Battleships.GameServer do
  use GenServer

  def init(user1, user2) do
    {:ok, Battleships.Game.new(user1, user2)}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
end
