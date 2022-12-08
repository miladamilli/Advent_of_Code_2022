defmodule Day08 do
  def part1 do
    map = parse_input()

    max_x = Map.keys(map) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    max_y = Map.keys(map) |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    map
    |> check_lines(:row, 0, max_x, 0, max_y)
    |> check_lines(:row, max_x, 0, 0, max_y)
    |> check_lines(:line, 0, max_y, 0, max_x)
    |> check_lines(:line, max_y, 0, 0, max_x)
    |> Enum.count(fn {_, %{visib: v}} -> v == :visible end)
  end

  defp check_lines(map, dir, from_x, to_x, from_y, to_y) do
    Enum.reduce(from_y..to_y, map, fn y, m -> check_line(dir, m, from_x, to_x, from_y, y) end)
  end

  defp check_line(dir, map, from_x, to_x, from_y, y) do
    Enum.reduce(from_x..to_x, {map, 0}, fn x, {m, last_height} ->
      pos = if dir == :row, do: {x, y}, else: {y, x}
      height = m[pos].h

      cond do
        x == from_x or y == from_y -> {Map.put(m, pos, %{m[pos] | visib: :visible}), height}
        height > last_height -> {Map.put(m, pos, %{m[pos] | visib: :visible}), height}
        true -> {m, last_height}
      end
    end)
    |> elem(0)
  end

  defp parse_input() do
    lines = "input/day08.txt" |> File.read!() |> String.split("\n", trim: true)

    for {line, y} <- Enum.with_index(lines),
        {height, x} <- Enum.with_index(String.codepoints(line)),
        into: %{} do
      {{x, y}, %{h: String.to_integer(height), visib: :unknown}}
    end
  end
end
