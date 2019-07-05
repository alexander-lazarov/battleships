defmodule BattleshipsWeb.UserlistChannel do
  use Phoenix.Channel

  def join("userlist:join", %{"username" => username}, socket) do
    case Battleships.Userlist.join(username) do
      :ok ->
        {:ok, socket}

      error ->
        {:error, socket}
    end
  end

  def handle_in("userlist:join", _message, socket), do: {:noreply, socket}

  def join("userlist:get", _message, socket), do: {:ok, socket}
  def handle_in("userlist:get", _message, socket), do: {:noreply, socket}
end
