defmodule Battleships.User do
  defstruct [:name]

  def new(name), do: %__MODULE__{name: name}
end
