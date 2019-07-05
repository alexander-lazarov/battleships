defmodule BattleshipsWeb.UserlistChannel do
  use Phoenix.Channel

  def join("userlist:join", %{"username" => username}, socket = %Phoenix.Socket{id: socket_id}) do
    case Battleships.Userlist.join(socket_id, username) do
      :ok ->
        # TODO - emit the new user to everyone
        {:ok, socket}

      error ->
        {:error, error}
    end
  end

  def handle_in("userlist:join", _message, socket), do: {:noreply, socket}

  def join("userlist:get", _message, socket), do: {:ok, socket}
  def handle_in("userlist:get", _message, socket), do: {:noreply, socket}

  def handle_out(event, payload, socket) do
    IO.puts("handle out")
    {:noreply, socket}
  end

  def terminate(reason, socket) do
    # TODO - remove the user from the list

    nil
  end
end
