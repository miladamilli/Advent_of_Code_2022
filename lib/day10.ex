defmodule Day10 do
  def part1 do
    instructions = parse_instructions() |> execute([{1, 1}])

    Enum.map([20, 60, 100, 140, 180, 220], fn at ->
      {r, c} = Enum.at(instructions, at - 1)
      r * c
    end)
    |> Enum.sum()
  end

  def part2 do
    instructions =
      parse_instructions()
      |> execute([{1, 1}])
      |> Enum.chunk_every(40, 40, :discard)

    for line <- instructions do
      for {register, cycle} <- line do
        if (rem(cycle, 40) - 1) in (register - 1)..(register + 1) do
          "█"
        else
          "░"
        end
      end
    end
    |> Enum.join("\n")
    |> tap(&IO.puts/1)
  end

  defp execute(["noop" | rest], [{register, cycles} | _] = log) do
    execute(rest, [{register, cycles + 1} | log])
  end

  defp execute([{"addx", value} | rest], [{register, cycles} | _] = log) do
    execute(rest, [{register + value, cycles + 1} | log])
  end

  defp execute([], log) do
    Enum.reverse(log)
  end

  defp parse_instructions() do
    "input/day10.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn line ->
      case String.split(line, " ") do
        ["addx", value] -> ["noop", {"addx", String.to_integer(value)}]
        noop -> noop
      end
    end)
  end
end
