defmodule Day05 do
  def part1, do: rearrange_crates(&Enum.reverse/1)
  def part2, do: rearrange_crates(&Function.identity/1)

  defp rearrange_crates(order) do
    crates_stacks = parse_crates()
    steps = parse_steps()

    Enum.reduce(steps, crates_stacks, fn [quantity, from, to], crates ->
      crates_to_move = crates[from] |> Enum.take(quantity) |> order.()

      crates
      |> Map.put(from, crates[from] |> Enum.drop(quantity))
      |> Map.put(to, crates_to_move ++ crates[to])
    end)
    |> Enum.map(fn {_k, v} -> hd(v) end)
    |> Enum.join()
  end

  defp parse_crates do
    """
    --J--B-T-
    --ML-QLR-
    --GQ-WSBL
    D-DT-MGVP
    T-NNNDJGN
    WHHSCNRWD
    NPPWHHBNG
    LCWCPTMZW
    """
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.map(&Enum.reject(&1, fn x -> x == "-" end))
    |> Enum.with_index(1)
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Map.new()
  end

  defp parse_steps() do
    "input/day05_steps.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ["move ", " from ", " to "]) |> tl |> Enum.map(&String.to_integer/1)
    end)
  end
end
