defmodule Day15 do
  @row 2_000_000
  def part1 do
    map = parse_input()

    sensors =
      Enum.filter(map, fn {{_x, _y}, %{is: is}} -> is == :sensor end)
      |> Enum.map(fn {pos, _} -> pos end)

    ranges = find_ranges(sensors, @row, map, [])
    [{from, to}] = reduce_ranges(ranges)
    non_empty = Enum.count(map, fn {{_x, y}, _} -> y == @row end)
    Enum.count(from..to) - non_empty
  end

  def part2 do
    map = parse_input()

    sensors =
      Enum.filter(map, fn {{_x, _y}, %{is: is}} -> is == :sensor end)
      |> Enum.map(fn {pos, _} -> pos end)

    find_beacon(sensors, map, 0)
  end

  defp find_ranges([{sx, sy} = sensor | rest], y, map, empty_positions) do
    {bx, by} = map[sensor].beacon
    md = abs(sx - bx) + abs(sy - by)

    if y not in (sy - md)..(sy + md) do
      find_ranges(rest, y, map, empty_positions)
    else
      x_offset = md - abs(y - sy)
      row_x_min = sx - x_offset
      row_x_max = sx + x_offset
      find_ranges(rest, y, map, [{row_x_min, row_x_max} | empty_positions])
    end
  end

  defp find_ranges([], _y, _map, empty_positions) do
    empty_positions |> Enum.sort()
  end

  defp reduce_ranges(ranges), do: reduce_ranges([hd(ranges)], tl(ranges))

  defp reduce_ranges([{prev_from, prev_to} | prev] = prev_all, [{from, to} | rest]) do
    if from - 1 <= prev_to do
      reduce_ranges([{prev_from, max(prev_to, to)} | prev], rest)
    else
      reduce_ranges([{from, to} | prev_all], rest)
    end
  end

  defp reduce_ranges(ranges, []) do
    ranges
  end

  defp find_beacon(sensors, map, y) do
    beacon =
      sensors
      |> find_ranges(y, map, [])
      |> reduce_ranges()

    case beacon do
      [_] -> find_beacon(sensors, map, y + 1)
      [{_, _}, {_, to}] -> (to + 1) * 4_000_000 + y
    end
  end

  defp parse_input() do
    "input/day15.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/-?\d+/, line) |> Enum.map(fn [i] -> String.to_integer(i) end)
    end)
    |> Enum.reduce(%{}, fn [sx, sy, bx, by], map ->
      map
      |> Map.put({sx, sy}, %{is: :sensor, beacon: {bx, by}})
      |> Map.put({bx, by}, %{is: :beacon})
    end)
  end
end
