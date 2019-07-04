defmodule BattleshipsWeb.RoomChannel do
  use Phoenix.Channel

  def join("userlist:join", message, socket) do
    {:ok, socket}
  end

  def handle_in(_, _, socket) do
    {:noreply, socket}
  end
end
