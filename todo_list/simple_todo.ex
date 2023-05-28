defmodule TodoList do
  def new(), do: %{}

  def add_entry(todo_list, date, title) do
    Map.update(
      todo_list,
      date,
      [title],
      fn titles -> [title | titles] end
    )
  end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end

my_list = TodoList.new()
my_list = TodoList.add_entry(my_list, "a date", "do 1")
my_list = TodoList.add_entry(my_list, "a date", "do 2")

IO.puts("#{TodoList.entries(my_list, "a date")}")
