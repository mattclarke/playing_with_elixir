defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.auto_id,
        entry
      )

    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        # Ensure id doesn't change
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(todo_list, entry_id) do
    entries = Map.delete(todo_list.entries, entry_id)
    %TodoList{todo_list | entries: entries}
  end
end

defmodule TodoList.CsvImporter do
  def import(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ","))
    |> Enum.map(fn [date_string, event] ->
      %{date: parse_date(date_string), title: event}
    end)
    |> TodoList.new()
  end

  defp parse_date(date_string) do
      [year, month, day] = 
      date_string
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

      {_, date} = Date.new(year, month, day)
      date
  end
end

todo_list = TodoList.CsvImporter.import("todos.csv")

IO.inspect(TodoList.entries(todo_list, ~D[2018-12-19]))
IO.puts("---------------")
IO.inspect(TodoList.entries(todo_list, ~D[2018-12-20]))
