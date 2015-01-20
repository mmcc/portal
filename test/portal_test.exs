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

  test "Push data between portals" do
    Portal.shoot(:magenta)
    Portal.shoot(:macaroni)
    portal = Portal.transfer(:magenta, :macaroni, [1,2,3,4])

    assert Portal.Door.get(:magenta) == [4,3,2,1]
    assert Portal.Door.get(:macaroni) == []
    Portal.push(portal, :right)
    assert Portal.Door.get(:magenta) == [3,2,1]
    assert Portal.Door.get(:macaroni) == [4]
  end
end
