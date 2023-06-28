file = "input.txt"

input_data =
  File.stream!(file)
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Stream.map(&String.graphemes/1)
  |> Stream.map(fn row ->
    row
    |> Enum.map(&String.to_integer/1)
  end)
  |> Enum.to_list()

defmodule Foo do
  def solve(input_data) do
    # From West
    {from_west, _} =
      input_data
      |> Enum.with_index()
      |> Enum.reduce({MapSet.new(), %{}}, fn {x, r}, {seen, best_row} ->
        z = Enum.zip(x, Enum.to_list(0..99))
        {sr, br} = from_west(z, r, -1, seen, best_row)
        {MapSet.union(sr, seen), br}
      end)

    # From East
    {from_east, _} =
      input_data
      |> Enum.with_index()
      |> Enum.reverse()
      |> Enum.reduce({MapSet.new(), %{}}, fn {x, r}, {seen, best_row} ->
        z = Enum.zip(x, Enum.to_list(0..99))
        {sr, br} = from_west(Enum.reverse(z), r, -1, seen, best_row)
        {MapSet.union(sr, seen), br}
      end)

    MapSet.union(from_west, from_east)
  end

  defp from_north(head, row, column, seen, best_row) do
    if head > Map.get(best_row, column, -1) do
      seen = MapSet.put(seen, {column, row})
      best_row = Map.update(best_row, column, head, fn _ -> head end)
      {seen, best_row}
    else
      {seen, best_row}
    end
  end

  defp from_west([{head, column} | tail], row, height, seen, best_row) do
    if head > height do
      {seen, best_row} = from_north(head, row, column, seen, best_row)
      seen = MapSet.put(seen, {column, row})
      from_west(tail, row, head, seen, best_row)
    else
      {seen, best_row} = from_north(head, row, column, seen, best_row)
      from_west(tail, row, height, seen, best_row)
    end
  end

  defp from_west([], _, _, seen, best_row) do
    {seen, best_row}
  end
end

result = Foo.solve(input_data)

IO.puts("Answer to part 1 = #{MapSet.size(result)}")
