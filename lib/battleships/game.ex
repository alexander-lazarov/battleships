defmodule Battleships.Game do
  defstruct [:user1, :user2, :pid]

  def new(user1, user2) do
    %__MODULE__{user1: user1, user2: user2}
  end
end
