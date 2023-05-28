defmodule Utils do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end

  def line_lengths!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length(&1))
    |> Enum.to_list()
  end

  def longest_line_length!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length(&1))
    |> Enum.max()
  end

  def longest_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.max_by(&String.length/1)
  end

  def words_per_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&length(String.split(&1)))
    |> Enum.to_list()
  end
end

IO.puts(Utils.large_lines!("example.txt"))

lengths = Utils.line_lengths!("example.txt")
# Use inspect otherwise will get the list as chars
IO.inspect(lengths, charlists: :as_lists)

IO.puts(Utils.longest_line_length!("example.txt"))

IO.puts(Utils.longest_line!("example.txt"))

lengths = Utils.words_per_line!("example.txt")
# Use inspect otherwise will get the list as chars
IO.inspect(lengths, charlists: :as_lists)
