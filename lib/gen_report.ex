defmodule GenReport do
  alias GenReport.Parser

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(filename) when is_list(filename) do
    filename
    |> Task.async_stream(&build/1)
    |> Enum.reduce(%{}, fn {:ok, report}, acc -> map_merge_recursion(report, acc) end)
  end

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(%{}, &calculate_report(&1, &2))
  end

  defp map_merge_recursion(map1, map2) do
    Map.merge(map1, map2, fn _, val1, val2 ->
      if is_map(val1), do: map_merge_recursion(val1, val2), else: val1 + val2
    end)
  end

  defp calculate_report([name, hours, _, month, year], report) do
    report
    |> nested_map_put_in(["all_hours", name], &update_hours(&1, hours))
    |> nested_map_put_in(["hours_per_month", name, month], &update_hours(&1, hours))
    |> nested_map_put_in(["hours_per_year", name, year], &update_hours(&1, hours))
  end

  defp update_hours(current_hours, new_hours) when is_nil(current_hours), do: new_hours
  defp update_hours(current_hours, new_hours), do: current_hours + new_hours

  def nested_map_put_in(data, keys, fun) do
    current_value = get_in(data, keys)

    put_in(
      data,
      Enum.map(keys, &Access.key(&1, %{})),
      fun.(if current_value, do: current_value, else: nil)
    )
  end
end
