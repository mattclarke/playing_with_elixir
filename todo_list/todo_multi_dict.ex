defmodule MultiDict do
  def new(), do: %{}

  def add(dict, key, value) do
    Map.update(
      dict,
      key,
      [value],
      fn values -> [value | values] end
    )
  end

  def get(dict, key) do
    Map.get(dict, key, [])
  end
end

defmodule TodoList do
  def new(), do: MultiDict.new()

  def add_entry(todo_list, date, title) do
    MultiDict.add(todo_list, date, title)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end

my_list = TodoList.new()
my_list = TodoList.add_entry(my_list, "a date", "do 1")
my_list = TodoList.add_entry(my_list, "a date", "do 2")

IO.puts("#{TodoList.entries(my_list, "a date")}")
