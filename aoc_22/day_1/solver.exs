file = "input.txt"

chunk_func = fn x, acc ->
  if x == "" do
    {:cont, acc, 0}
  else
    {:cont, String.to_integer(x) + acc}
  end
end

after_chunk_func = fn
  0 -> {:cont, 0}
  acc -> {:cont, acc, 0}
end

data =
  File.stream!(file)
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Enum.chunk_while(
    0,
    chunk_func,
    after_chunk_func
  )
  |> Enum.max()

IO.puts("Answer to part 1 = #{data}")

data =
  File.stream!(file)
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Enum.chunk_while(
    0,
    chunk_func,
    after_chunk_func
  )
  |> Enum.to_list()
  |> Enum.sort(&(&1 > &2))
  |> Enum.take(3)
  |> Enum.sum()

IO.puts("Answer to part 2 = #{data}")
