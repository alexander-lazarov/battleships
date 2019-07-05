defmodule BattleshipsWeb.UserlistChannel do
  use Phoenix.Channel

  def join("userlist:join", %{"username" => username}, socket = %Phoenix.Socket{id: socket_id}) do
    case Battleships.UserlistServer.join(socket_id, username) do
      :ok ->
        broadcast_list()
        {:ok, socket}

      error ->
        {:error, error}
    end
  end

  def join("userlist:get", _message, socket) do
    {:ok, %{id: socket.id}, socket}
  end

  def join("userlist:" <> user_id, _message, socket) do
    case user_id == socket.id do
      true -> {:ok, socket}
      false -> {:error, "not your channel"}
    end
  end

  def handle_in("getusers", _, socket) do
    push(socket, "list", %{users: Battleships.UserlistServer.get()})

    {:noreply, socket}
  end

  def handle_in("challenge", %{"user" => user}, socket) do
    if socket.id == user do
      push(socket, "gameError", %{error: "Cannot start game with yourself"})
    else
      Battleships.GamelistServer.start_game(socket.id, user)
    end

    {:noreply, socket}
  end

  def handle_in(_, _, socket) do
    IO.puts("Unknown message")

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    Battleships.UserlistServer.leave(socket.id)
    broadcast_list()

    # TODO - fix return value
  end

  defp broadcast_list do
    BattleshipsWeb.Endpoint.broadcast(
      "userlist:get",
      "list",
      %{users: Battleships.UserlistServer.get()}
    )
  end
end
