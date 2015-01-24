defmodule Portal do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Portal.Door, [])
    ]

    opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @derive [Access]
  defstruct [:left, :right]

  @doc """
  Starts transferring `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    # First add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end

    # Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the `left` or `right` in the given `portal`
  """
  def push(portal, direction) do
    case Portal.Door.pop(portal[opposite_direction(direction)]) do
      :error   -> :ok
      {:ok, h} -> Portal.Door.push(portal[direction], h)
    end

    portal
  end

  @doc """
  Pushes data to the right in the given `portal`
  """
  def push_right(portal) do
    Portal.push(portal, :right)

    portal
  end

  @doc """
  Pushes data to the left in the given `portal`
  """
  def push_left(portal) do
    Portal.push(portal, :left)

    portal
  end


  @doc """
  Private method for switching the directions around when pushing between portals
  """
  defp opposite_direction(direction) do
    case direction do
      :left  -> :right
      :right -> :left
    end
  end

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door  = inspect(left)
    right_door = inspect(right)

    left_data  = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end
