defmodule Day03 do
  def part1 do
    "input/day03.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack ->
      {comp1, comp2} = String.codepoints(rucksack) |> Enum.split(div(String.length(rucksack), 2))

      MapSet.intersection(MapSet.new(comp1), MapSet.new(comp2))
      |> Enum.join()
      |> value
    end)
    |> Enum.sum()
  end

  def part2 do
    "input/day03.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack -> rucksack |> String.codepoints() |> MapSet.new() end)
    |> Enum.chunk_every(3)
    |> Enum.map(fn rucksack ->
      Enum.reduce(rucksack, &MapSet.intersection/2) |> Enum.join() |> value
    end)
    |> Enum.sum()
  end

  def value(<<item::utf8>>) when item in ?a..?z, do: item - 96
  def value(<<item::utf8>>) when item in ?A..?Z, do: item - 38
end
