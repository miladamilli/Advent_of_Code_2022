defmodule Day21 do
  def part1 do
    monkeys = parse_input()
    run("root", monkeys)
  end

  defp run(monkey, monkeys) do
    case monkeys[monkey] do
      result when is_integer(result) -> result
      [m1, "+", m2] -> run(m1, monkeys) + run(m2, monkeys)
      [m1, "-", m2] -> run(m1, monkeys) - run(m2, monkeys)
      [m1, "*", m2] -> run(m1, monkeys) * run(m2, monkeys)
      [m1, "/", m2] -> run(m1, monkeys) / run(m2, monkeys)
    end
  end

  defp parse_input() do
    "input/day21.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.into(%{}, fn line ->
      [monkey, op] = String.split(line, ": ")

      case Integer.parse(op) do
        {int, ""} -> {monkey, int}
        :error -> {monkey, String.split(op, " ")}
      end
    end)
  end
end
