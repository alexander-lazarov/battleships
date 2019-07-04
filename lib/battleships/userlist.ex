defmodule Battleships.Userlist do
  use GenServer

  @type state :: MapSet.t()
  @type userlist :: list(String.t())

  def init(_) do
    {:ok, MapSet.new()}
  end

  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec get() :: userlist()
  def get() do
    GenServer.call(__MODULE__, :get)
  end

  @spec add(String.t()) :: :ok | :in_use
  def add(new_user), do: GenServer.call(__MODULE__, {:add, new_user})

  @spec handle_call(:get, any(), state()) :: {:reply, userlist(), state()}
  def handle_call(:get, _from, state), do: {:reply, state |> MapSet.to_list(), state}

  @spec handle_call({:add, String.t()}, any(), state()) :: {:reply, :ok | :in_use, state()}
  def handle_call({:add, new_user}, _from, state) do
    case state |> MapSet.member?(new_user) do
      true -> {:reply, :in_use, state}
      false -> {:reply, :ok, state |> MapSet.put(new_user)}
    end
  end
end
