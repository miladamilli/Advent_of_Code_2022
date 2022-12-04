defmodule Day04 do
  def part1, do: overlap(&Enum.all?/2)
  def part2, do: overlap(&Enum.any?/2)

  defp overlap(fun) do
    "input/day04.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [elf1, elf2] = String.split(line, ",")
      [elf_range(elf1), elf_range(elf2)]
    end)
    |> Enum.filter(fn [elf1, elf2] ->
      fun.(elf1, fn e -> e in elf2 end) or fun.(elf2, fn e -> e in elf1 end)
    end)
    |> Enum.count()
  end

  defp elf_range(elf) do
    [from, to] = String.split(elf, "-")
    String.to_integer(from)..String.to_integer(to)
  end
end
