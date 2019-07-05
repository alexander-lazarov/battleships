defmodule BattleshipsWeb.UserlistChannel do
  use Phoenix.Channel

  def join("userlist:join", %{"username" => username}, socket = %Phoenix.Socket{id: socket_id}) do
    case Battleships.UserlistServer.join(socket_id, username) do
      :ok ->
        broadcast_list
        {:ok, socket}

      error ->
        {:error, error}
    end
  end

  def join("userlist:get", _message, socket) do
    {:ok, socket}
  end

  def handle_in("getusers", _, socket) do
    push(socket, "list", %{users: Battleships.UserlistServer.get()})

    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Battleships.UserlistServer.leave(socket.id)
    broadcast_list

    # TODO - fix return value
  end

  defp broadcast_list do
    BattleshipsWeb.Endpoint.broadcast_from!(
      self(),
      "userlist:get",
      "list",
      %{users: Battleships.UserlistServer.get()}
    )
  end
end
