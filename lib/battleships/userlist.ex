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
  def get(), do: GenServer.call(__MODULE__, :get)

  @spec join(String.t()) :: :ok | :in_use
  def join(new_user), do: GenServer.call(__MODULE__, {:join, new_user})

  @spec leave(String.t()) :: :ok | :unknown_user
  def leave(user), do: GenServer.call(__MODULE__, {:leave, user})

  @spec handle_call(:get, any(), state()) :: {:reply, userlist(), state()}
  def handle_call(:get, _from, state), do: {:reply, state |> MapSet.to_list(), state}

  @spec handle_call({:join, String.t()}, any(), state()) :: {:reply, :ok | :in_use, state()}
  def handle_call({:join, new_user}, _from, state) do
    case state |> MapSet.member?(new_user) do
      true -> {:reply, :in_use, state}
      false -> {:reply, :ok, state |> MapSet.put(new_user)}
    end
  end

  @spec handle_call({:leave, String.t()}, any(), state()) ::
          {:reply, :ok | :unknown_user, state()}
  def handle_call({:leave, user}, _from, state) do
    case state |> MapSet.member?(user) do
      true -> {:reply, :ok, state |> MapSet.delete(user)}
      false -> {:reply, :unknown_user, state}
    end
  end
end
