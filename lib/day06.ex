defmodule Day06 do
  def part1, do: get_input() |> process(4, 4)
  def part2, do: get_input() |> process(14, 14)

  defp process(data, length, position) do
    d = Enum.take(data, length)

    if Enum.uniq(d) == d do
      position
    else
      process(tl(data), length, position + 1)
    end
  end

  defp get_input() do
    "input/day06.txt"
    |> File.read!()
    |> String.codepoints()
  end
end
