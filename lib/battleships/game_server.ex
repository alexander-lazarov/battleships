defmodule Battleships.GameServer do
  use GenServer

  def init([user1, user2]) do
    {:ok, Battleships.Game.new(user1, user2)}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def user_in_game?(pid, user_id) do
    GenServer.call(pid, {:user_in_game?, user_id})
  end

  def handle_call({:user_in_game?, user_id}, _form, state) do
    result = state.user1 == user_id || state.user2 == user_id

    {:reply, result, state}
  end
end
