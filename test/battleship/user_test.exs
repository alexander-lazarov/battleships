defmodule BattleshipsWeb.UserTest do
  use ExUnit.Case, async: true

  test "that you can create a user" do
    new_user = Battleships.User.new("user1")

    assert "user1" == new_user.name
  end
end
