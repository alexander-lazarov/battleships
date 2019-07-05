defmodule Battleships.Userlist do
  use GenServer

  @type state :: %{required(username) => socket_id}
  @type username :: String.t()
  @type socket_id :: String.t()
  @type userlist :: list(username)

  def init(_), do: {:ok, %{}}

  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec get() :: userlist()
  def get(), do: GenServer.call(__MODULE__, :get)

  @spec join(socket_id, username) :: :ok | :username_in_use | :socket_id_in_use
  def join(socket_id, new_user) do
    GenServer.call(__MODULE__, {:join, socket_id, new_user})
  end

  @spec id_exists?(socket_id()) :: bool()
  def id_exists?(socket_id) do
    GenServer.call(__MODULE__, {:id_exists?, socket_id})
  end

  @spec leave(socket_id()) :: :ok | :unknown_socket_id
  def leave(user), do: GenServer.call(__MODULE__, {:leave, user})

  @spec handle_call(:get, any(), state()) :: {:reply, userlist(), state()}
  def handle_call(:get, _from, state) do
    {:reply, Map.values(state), state}
  end

  @spec handle_call({:join, socket_id(), username()}, any(), state()) ::
          {:reply, :ok | :username_in_use | :socket_id_in_use, state()}
  def handle_call({:join, id, new_user}, _from, state) do
    case {
      Map.has_key?(state, id),
      Enum.member?(Map.values(state) |> Enum.map(& &1.name), new_user)
    } do
      {true, _} ->
        {:reply, :socket_id_in_use, state}

      {false, true} ->
        {:reply, :username_in_use, state}

      {false, false} ->
        {:reply, :ok, Map.put_new(state, id, Battleships.User.new(new_user))}
    end
  end

  @spec handle_call({:id_exists?, socket_id}, any(), state()) :: {:reply, bool(), state}
  def handle_call({:id_exists?, socket_id}, _from, state) do
    {:reply, Map.has_key?(state, socket_id), state}
  end

  @spec handle_call({:leave, socket_id()}, any(), state()) ::
          {:reply, :ok | :unknown_socket_id, state()}
  def handle_call({:leave, socket_id}, _from, state) do
    case state |> Map.has_key?(socket_id) do
      true -> {:reply, :ok, state |> Map.delete(socket_id)}
      false -> {:reply, :unknown_socket_id, state}
    end
  end
end
