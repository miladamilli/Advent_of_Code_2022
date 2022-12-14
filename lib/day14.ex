defmodule Day14 do
  @start {500, 0}

  def part1 do
    map = parse_input()
    {{_, y_min}, _} = Enum.min_by(map, fn {{_x, y}, _} -> y end)

    pour_sand(@start, y_min, map)
    |> Enum.count(fn {{_x, _y}, what} -> what == "." end)
  end

  defp pour_sand({x, y}, floor, map) do
    cond do
      y == floor -> map
      map[{x, y - 1}] == nil -> pour_sand({x, y - 1}, floor, map)
      map[{x - 1, y - 1}] == nil -> pour_sand({x - 1, y - 1}, floor, map)
      map[{x + 1, y - 1}] == nil -> pour_sand({x + 1, y - 1}, floor, map)
      true -> pour_sand(@start, floor, Map.put(map, {x, y}, "."))
    end
  end

  def part2 do
    map = parse_input()
    {{_, y_min}, _} = Enum.min_by(map, fn {{_x, y}, _} -> y end)

    floor = y_min - 2

    {:reached_the_top, map} = pour_sand2(@start, floor, map)
    Enum.count(map, fn {{_x, _y}, what} -> what == "." end)
  end

  defp pour_sand2({x, y}, floor, map) do
    cond do
      y - 1 == floor -> pour_sand2(@start, floor, Map.put(map, {x, y}, "."))
      map[{x, y - 1}] == nil -> pour_sand2({x, y - 1}, floor, map)
      map[{x - 1, y - 1}] == nil -> pour_sand2({x - 1, y - 1}, floor, map)
      map[{x + 1, y - 1}] == nil -> pour_sand2({x + 1, y - 1}, floor, map)
      {x, y} != @start -> pour_sand2(@start, floor, Map.put(map, {x, y}, "."))
      true -> {:reached_the_top, Map.put(map, {x, y}, ".")}
    end
  end

  defp parse_input() do
    "input/day14.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      points = String.split(line, " -> ")

      Enum.map(points, fn p ->
        [x, y] = String.split(p, ",")
        {String.to_integer(x), String.to_integer(y)}
      end)
    end)
    |> Enum.reduce(%{}, &line_of_rocks/2)
  end

  defp line_of_rocks([_], map) do
    map
  end

  defp line_of_rocks([{x1, y1}, {x2, y2} | rest], map) do
    map =
      for x <- x1..x2, y <- y1..y2, into: map do
        {{x, -y}, "#"}
      end

    line_of_rocks([{x2, y2} | rest], map)
  end
end
