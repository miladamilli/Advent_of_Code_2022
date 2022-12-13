defmodule Day13 do
  def part1 do
    "input/day13.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn l -> String.split(l, "\n", trim: true) end)
    |> Enum.map(fn [left, right] ->
      {l, _} = Code.eval_string(left)
      {r, _} = Code.eval_string(right)
      compare(l, r)
    end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {order, _} -> order end)
    |> Enum.map(fn {_, index} -> index end)
    |> Enum.sum()
  end

  def part2 do
    input = "input/day13.txt" |> File.read!() |> String.split("\n", trim: true)

    sorted =
      ["[[2]]", "[[6]]" | input]
      |> Enum.map(fn l -> Code.eval_string(l) |> elem(0) end)
      |> Enum.sort(&compare/2)

    i1 = Enum.find_index(sorted, fn packet -> packet == [[2]] end) + 1
    i2 = Enum.find_index(sorted, fn packet -> packet == [[6]] end) + 1
    i1 * i2
  end

  def compare(left, right) when is_integer(left) and is_integer(right) do
    cond do
      left < right -> true
      left > right -> false
      left == right -> :equal
    end
  end

  def compare([left | left_rest], [right | right_rest]) do
    case compare(left, right) do
      :equal -> compare(left_rest, right_rest)
      result -> result
    end
  end

  def compare(left, right) when is_integer(left), do: compare([left], right)
  def compare(left, right) when is_integer(right), do: compare(left, [right])
  def compare([], []), do: :equal
  def compare([], _), do: true
  def compare(_, []), do: false
end
