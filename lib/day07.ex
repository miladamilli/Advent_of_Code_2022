defmodule Day07 do
  def part1 do
    browse_filesystem()
    |> Enum.filter(fn {_dir, size} -> size <= 100_000 end)
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.sum()
  end

  def part2() do
    total_space = 70_000_000
    total_space_needed = 30_000_000

    filesystem = browse_filesystem()
    used_space = filesystem[".."]

    free_space = total_space - used_space
    need_to_delete = total_space_needed - free_space

    filesystem
    |> Enum.filter(fn {_dir, size} -> size >= need_to_delete end)
    |> Enum.min_by(fn {_dir, size} -> size end)
  end

  defp browse_filesystem() do
    "input/day07.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, []}, fn command, {map, dirs} -> parse(command, map, dirs) end)
    |> elem(0)
  end

  defp parse("$ cd /", map, _dirs) do
    {map, [".."]}
  end

  defp parse("$ cd ..", map, dirs) do
    {map, tl(dirs)}
  end

  defp parse("$ cd " <> dir_name, map, dirs) do
    {map, [dir_name | dirs]}
  end

  defp parse("$ ls", map, dirs), do: {map, dirs}
  defp parse("dir " <> _dir, map, dirs), do: {map, dirs}

  defp parse(file, map, dirs) do
    [size, _file_name] = String.split(file, " ")
    {add_file_size(dirs, String.to_integer(size), map), dirs}
  end

  defp add_file_size([], _size, map) do
    map
  end

  defp add_file_size(dirs, size, map) do
    add_file_size(tl(dirs), size, Map.update(map, Enum.join(dirs, "/"), size, &(&1 + size)))
  end
end
