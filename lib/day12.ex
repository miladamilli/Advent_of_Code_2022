defmodule Day12 do
  @moduledoc """
  I gradually traverse the "map" using some kind of "flood fill" algorithm.
  I start at my current position and its distance 0.
  If the point I'm currently checking is not yet visited (its distance is still unknown),
  I add its distance to the map,
  and add its neighbours to the end of the queue of the points to visit next
  (together with their distances, which are current distance + 1).

  I skip checking already visited points. (Because of the order in which points are
  being traversed, the new distance will never be shorter than the one previously set.)

  In part 2, instead of just one point, I add all the starting points
  to the queue of the points to visit.
  """

  def part1 do
    {start, finish, map} = parse_input()
    map = walk([{start, 0}], map)
    map[finish].distance
  end

  def part2 do
    {_start, finish, map} = parse_input()

    starting_points =
      Enum.filter(map, fn {_, %{height: h}} -> h == ?a end)
      |> Enum.map(fn {pos, _} -> {pos, 0} end)

    map = walk(starting_points, map)
    map[finish].distance
  end

  defp walk([], map) do
    map
  end

  defp walk([{position, distance} | rest], map) do
    if map[position].distance == :unknown do
      new_map = put_in(map, [position, :distance], distance)
      possible_ways = where_can_i_go(position, map) |> Enum.map(fn p -> {p, distance + 1} end)
      walk(rest ++ possible_ways, new_map)
    else
      walk(rest, map)
    end
  end

  defp where_can_i_go({x, y} = pos, map) do
    Enum.filter([{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}], fn n ->
      Map.has_key?(map, n) and map[n].height - map[pos].height <= 1
    end)
  end

  defp parse_input() do
    input = "input/day12.txt" |> File.read!() |> String.split("\n", trim: true)

    map =
      for {line, y} <- Enum.with_index(input),
          {char, x} <- String.to_charlist(line) |> Enum.with_index(),
          into: %{} do
        {{x, y}, %{height: char, distance: :unknown}}
      end

    {start, _} = Enum.find(map, fn {_pos, %{height: h}} -> h == ?S end)
    {finish, _} = Enum.find(map, fn {_pos, %{height: h}} -> h == ?E end)

    map = map |> put_in([start, :height], ?a) |> put_in([finish, :height], ?z)
    {start, finish, map}
  end
end
