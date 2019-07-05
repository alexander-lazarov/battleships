defmodule Battleships.GamesSupervisor do
  use DynamicSupervisor

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(user1, user2) do
    spec = {Battleships.GameServer, [user1, user2]}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
