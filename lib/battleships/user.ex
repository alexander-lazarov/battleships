defmodule Battleships.User do
  @derive Jason.Encoder
  defstruct [:name]

  def new(name), do: %__MODULE__{name: name}
end
