defmodule Battheships.GamelistSupervisor do
  use Supervisor

  def init(_init_arg) do
    children = [
      Battleships.GamelistServer,
      Battleships.GamesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end
end
