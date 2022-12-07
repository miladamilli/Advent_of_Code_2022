defmodule Day07Test do
  use ExUnit.Case

  test "test" do
    assert Day07.part1() == 1_306_611
    assert match?({_, 13_210_366}, Day07.part2())
  end
end
