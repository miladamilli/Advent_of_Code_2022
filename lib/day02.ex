defmodule Day02 do
  def part1 do
    "input/day02.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(&play1/1)
    |> Enum.sum()
  end

  defp play1([opponent, me]) do
    me =
      case me do
        "X" -> "A"
        "Y" -> "B"
        "Z" -> "C"
      end

    my_score(me) + play_turn(opponent, me)
  end

  defp play_turn(a, a), do: 3
  defp play_turn("A", "B"), do: 6
  defp play_turn("B", "C"), do: 6
  defp play_turn("C", "A"), do: 6
  defp play_turn(_, _), do: 0

  def part2 do
    "input/day02.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(&play2/1)
    |> Enum.sum()
  end

  defp play2([opponent, result]) do
    my_turn =
      case result do
        "Y" ->
          opponent

        "Z" ->
          case opponent do
            "A" -> "B"
            "B" -> "C"
            "C" -> "A"
          end

        "X" ->
          case opponent do
            "A" -> "C"
            "B" -> "A"
            "C" -> "B"
          end
      end

    my_score(my_turn) + score(result)
  end

  defp score("X"), do: 0
  defp score("Y"), do: 3
  defp score("Z"), do: 6

  defp my_score(my_turn) do
    case my_turn do
      "A" -> 1
      "B" -> 2
      "C" -> 3
    end
  end
end
