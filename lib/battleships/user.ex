defmodule Battleships.User do
  @derive Jason.Encoder
  defstruct [:id, :name]

  def new(id, name), do: %__MODULE__{id: id, name: name}
end
