defmodule BattleshipsWeb.UserTest do
  use ExUnit.Case, async: true

  test "that you can create a user" do
    new_user = Battleships.User.new("id1", "user1")

    assert "id1" == new_user.id
    assert "user1" == new_user.name
  end
end
