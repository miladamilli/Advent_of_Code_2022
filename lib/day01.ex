defmodule Day01 do
  def part1 do
    "input/day01.txt"
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(fn food ->
      String.split(food, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  def part2 do
    "input/day01.txt"
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(fn food ->
      String.split(food, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end
end
