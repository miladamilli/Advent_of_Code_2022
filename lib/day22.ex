defmodule Day22 do
  def part1 do
    map = parse_map()
    path = parse_path()
    {start, _} = Enum.filter(map, fn {{_x, y}, _} -> y == 0 end) |> Enum.sort() |> Enum.at(0)
    go(start, :right, path, map)
  end

  @facing %{right: 0, down: 1, left: 2, up: 3}

  defp go({x, y}, dir, [], _map) do
    1000 * (y + 1) + 4 * (x + 1) + @facing[dir]
  end

  defp go(pos, dir, [step | path], map) do
    case step do
      d when d in [:r, :l] ->
        go(pos, turn(dir, d), path, map)

      steps ->
        new_pos = step(steps, pos, dir, map)
        go(new_pos, dir, path, map)
    end
  end

  defp turn(actual_dir, dir) do
    case {actual_dir, dir} do
      {:right, :r} -> :down
      {:left, :r} -> :up
      {:up, :r} -> :right
      {:down, :r} -> :left
      {:right, :l} -> :up
      {:left, :l} -> :down
      {:up, :l} -> :left
      {:down, :l} -> :right
    end
  end

  defp step(0, pos, _dir, _map) do
    pos
  end

  defp step(steps, {x, y} = pos, dir, map) do
    new_pos =
      case dir do
        :right -> {x + 1, y}
        :left -> {x - 1, y}
        :up -> {x, y - 1}
        :down -> {x, y + 1}
      end

    tile = map[new_pos]

    cond do
      tile == "#" ->
        step(0, pos, dir, map)

      tile == "." ->
        step(steps - 1, new_pos, dir, map)

      tile in [" ", nil] ->
        new_pos = find_pos_on_other_side(pos, dir, map)

        if map[new_pos] == "." do
          step(steps - 1, new_pos, dir, map)
        else
          step(0, pos, dir, map)
        end
    end
  end

  defp find_pos_on_other_side({x, y}, dir, map) do
    line =
      cond do
        dir in [:right, :left] ->
          Enum.filter(map, fn {{_, yy}, val} -> yy == y and val != " " end)

        dir in [:up, :down] ->
          Enum.filter(map, fn {{xx, _}, val} -> xx == x and val != " " end)
      end

    line = line |> Enum.sort()

    {new_pos, _value} =
      case dir do
        :right -> Enum.at(line, 0)
        :left -> Enum.at(line, -1)
        :up -> Enum.at(line, -1)
        :down -> Enum.at(line, 0)
      end

    new_pos
  end

  defp parse_map() do
    lines =
      "input/day22_map.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    for {line, y} <- Enum.with_index(lines),
        {char, x} <- Enum.with_index(String.codepoints(line)),
        into: %{} do
      {{x, y}, char}
    end
  end

  defp parse_path() do
    "input/day22_path.txt"
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("R")
    |> Enum.intersperse(:r)
    |> Enum.map(fn l ->
      if is_atom(l) do
        l
      else
        String.split(l, "L") |> Enum.intersperse(:l)
      end
    end)
    |> List.flatten()
    |> Enum.map(fn l ->
      if is_atom(l) do
        l
      else
        String.to_integer(l)
      end
    end)
  end
end
