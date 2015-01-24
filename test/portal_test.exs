defmodule PortalTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Shooting a portal" do
    {success, _} = Portal.shoot(:orange)
    assert success == :ok
  end

  test "Initiating a transfer between portals" do
    Portal.shoot(:black)
    Portal.shoot(:blue)
    portal = Portal.transfer(:black, :blue, [1,2,3,4])

    assert portal.left == :black
    assert portal.right == :blue
  end

  test "Push data to the portal on the right" do
    Portal.shoot(:magenta)
    Portal.shoot(:macaroni)
    portal = Portal.transfer(:magenta, :macaroni, [1,2,3,4])

    assert Portal.Door.get(:magenta) == [4,3,2,1]
    assert Portal.Door.get(:macaroni) == []
    Portal.push_right(portal)
    assert Portal.Door.get(:magenta) == [3,2,1]
    assert Portal.Door.get(:macaroni) == [4]
  end

  test "Push data to the portal on the left" do
    Portal.shoot(:z)
    Portal.shoot(:y)
    portal = Portal.transfer(:z, :y, [1,2,3,4])

    assert Portal.Door.get(:z) == [4,3,2,1]
    assert Portal.Door.get(:y) == []
    Portal.push_right(portal)
    Portal.push_right(portal)
    assert Portal.Door.get(:z) == [2,1]
    assert Portal.Door.get(:y) == [3,4]
    Portal.push_left(portal)
    assert Portal.Door.get(:z) == [3,2,1]
    assert Portal.Door.get(:y) == [4]
  end
end
