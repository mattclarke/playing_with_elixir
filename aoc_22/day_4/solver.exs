file = "input.txt"

input_data =
  File.stream!(file)
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Stream.map(&String.split(&1, ","))
  |> Stream.map(fn x ->
    first = String.split(List.first(x), "-")
    second = String.split(List.last(x), "-")
    {List.to_tuple(first), List.to_tuple(second)}
  end)
  |> Enum.to_list()

find_contained = fn {x, y} ->
  {x1, x2} = x
  x1 = String.to_integer(x1)
  x2 = String.to_integer(x2)
  {y1, y2} = y
  y1 = String.to_integer(y1)
  y2 = String.to_integer(y2)

  if x1 >= y1 and x2 <= y2 do
    1
  else
    if y1 >= x1 and y2 <= x2 do
      1
    else
      0
    end
  end
end

data =
  input_data
  |> Stream.map(&find_contained.(&1))
  |> Enum.sum()

IO.puts("Answer to part 1 = #{data}")

# convert_to_score = fn char ->
#   value = :binary.first(char)

#   if value >= :binary.first("a") do
#     value - :binary.first("a") + 1
#   else
#     value - :binary.first("A") + 27
#   end
# end

# find_match = fn comps ->
#   comps
#   |> Stream.map(&MapSet.new/1)
#   |> Enum.reduce(&MapSet.intersection/2)
#   |> Enum.at(0)
# end

# data =
#   input_data
#   |> Stream.map(fn x -> Enum.chunk_every(x, div(length(x), 2)) end)
#   |> Stream.map(&find_match.(&1))
#   |> Stream.map(&convert_to_score.(&1))
#   |> Enum.sum()

# IO.puts("Answer to part 1 = #{data}")

# data =
#   Stream.chunk_every(input_data, 3)
#   |> Stream.map(&find_match.(&1))
#   |> Stream.map(&convert_to_score.(&1))
#   |> Enum.sum()

# IO.puts("Answer to part 2 = #{data}")
