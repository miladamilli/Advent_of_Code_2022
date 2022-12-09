defmodule Day09 do
  def part1 do
    parse_input()
    |> move([{0, 0}, {0, 0}], MapSet.new())
    |> MapSet.size()
  end

  def part2 do
    parse_input()
    |> move(List.duplicate({0, 0}, 10), MapSet.new())
    |> MapSet.size()
  end

  defp move([], _rope, tail_path) do
    tail_path
  end

  defp move([dir | rest], [head | knots], tail_path) do
    new_head = move_head(dir, head)
    new_rope = Enum.scan([new_head | knots], fn tail, head -> follow(head, tail) end)
    move(rest, new_rope, MapSet.put(tail_path, Enum.at(new_rope, -1)))
  end

  defp move_head("L", {x, y}), do: {x - 1, y}
  defp move_head("R", {x, y}), do: {x + 1, y}
  defp move_head("U", {x, y}), do: {x, y + 1}
  defp move_head("D", {x, y}), do: {x, y - 1}

  defp follow({hx, hy}, {tx, ty} = tail) do
    if abs(hx - tx) <= 1 and abs(hy - ty) <= 1 do
      tail
    else
      {coordinate(hx, tx), coordinate(hy, ty)}
    end
  end

  defp coordinate(h, t) do
    cond do
      h == t -> t
      h > t -> t + 1
      h < t -> t - 1
    end
  end

  defp parse_input() do
    "input/day09.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn line ->
      [dir, steps] = String.split(line)
      List.duplicate(dir, String.to_integer(steps))
    end)
  end
end
