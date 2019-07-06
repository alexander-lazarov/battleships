defmodule BattleshipsWeb.GameChannel do
  use Phoenix.Channel

  def join("game:" <> game_id, %{}, socket = %Phoenix.Socket{id: socket_id}) do
    case Battleship.GamelistServer.user_in_game?(socket_id, game_id) do
      true ->
        {:ok, socket}

      false ->
        {:error, "Not allowed"}
    end
  end
end
