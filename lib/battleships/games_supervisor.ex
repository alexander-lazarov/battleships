defmodule Battleships.GamesSupervisor do
  use DynamicSupervisor

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child() do
    spec = {Battleships.GameServer, []}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
