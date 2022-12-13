defmodule Day11 do
  def part1 do
    monkeys = parse_input()

    worry_level_relief = fn n -> div(n, 3) end

    [most_active1, most_active2] = most_active_monkeys(monkeys, 20, worry_level_relief)
    most_active1 * most_active2
  end

  def part2 do
    monkeys = parse_input()
    monkey_factor = Enum.map(monkeys, fn {_, %{divisible_by_n: n}} -> n end) |> Enum.product()

    worry_level_relief = fn n -> rem(n, monkey_factor) end

    [most_active1, most_active2] = most_active_monkeys(monkeys, 10000, worry_level_relief)
    most_active1 * most_active2
  end

  defp most_active_monkeys(monkeys, rounds, worry_level_relief) do
    Enum.reduce(1..rounds, monkeys, fn _, mms ->
      Enum.reduce(0..(length(monkeys |> Map.keys()) - 1), mms, fn i, ms ->
        play(ms[i], ms, worry_level_relief)
      end)
    end)
    |> Enum.sort_by(fn {_, %{inspected: i}} -> i end, :desc)
    |> Enum.take(2)
    |> Enum.map(fn {_, %{inspected: i}} -> i end)
  end

  defp play(monkey, monkeys, worry_level_relief) do
    Enum.reduce(monkey.items, monkeys, fn item, ms ->
      item_worry = monkey.op.(item) |> worry_level_relief.()

      if item_worry |> monkey.divisible.() do
        update_item(item_worry, monkey.if_true, ms)
      else
        update_item(item_worry, monkey.if_false, ms)
      end
    end)
    |> put_in([monkey.number, :items], [])
    |> update_in([monkey.number, :inspected], &(&1 + length(monkey.items)))
  end

  defp update_item(item, add_to, monkeys) do
    update_in(monkeys, [add_to, :items], &(&1 ++ [item]))
  end

  defp parse_input() do
    "input/day11.txt"
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("\n\n", trim: true)
    |> Enum.into(%{}, fn m ->
      monkey =
        Enum.reduce(String.split(m, "\n"), %{}, fn line, mnk -> parse(line, mnk) end)
        |> Map.put(:inspected, 0)

      {monkey.number, monkey}
    end)
  end

  defp parse("Monkey " <> number, monkey) do
    Map.put(monkey, :number, number |> String.trim_trailing(":") |> String.to_integer())
  end

  defp parse("  Starting items: " <> items, monkey) do
    Map.put(monkey, :items, String.split(items, ", ") |> Enum.map(&String.to_integer/1))
  end

  defp parse("  Operation: new = old " <> operation, monkey) do
    op =
      case String.split(operation) do
        ["*", "old"] -> fn x -> x * x end
        ["*", n] -> fn x -> x * String.to_integer(n) end
        ["+", n] -> fn x -> x + String.to_integer(n) end
      end

    Map.put(monkey, :op, op)
  end

  defp parse("  Test: divisible by " <> n, monkey) do
    n = String.to_integer(n)
    op = fn x -> rem(x, n) == 0 end

    Map.put(monkey, :divisible, op) |> Map.put(:divisible_by_n, n)
  end

  defp parse("    If true: throw to monkey " <> m, monkey) do
    Map.put(monkey, :if_true, m |> String.to_integer())
  end

  defp parse("    If false: throw to monkey " <> m, monkey) do
    Map.put(monkey, :if_false, m |> String.to_integer())
  end
end
