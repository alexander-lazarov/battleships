defmodule BattleshipsWeb.GamelistTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, _} = Application.ensure_all_started(:battleships)

    on_exit(fn ->
      Application.stop(:battleships)
    end)

    :ok
  end
end
