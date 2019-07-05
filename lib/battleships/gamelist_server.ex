defmodule Battleships.GamelistServer do
  use GenServer

  def init(_), do: {:ok, []}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
end
