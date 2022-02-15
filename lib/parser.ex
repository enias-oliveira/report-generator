defmodule GenReport.Parser do
  def parse_file(filename) do
    File.stream!(filename)
    |> Enum.map(&parse_csv_line_to_list/1)
  end

  defp parse_csv_line_to_list(raw_line) do
    integer_to_months = %{
      "1" => "janeiro",
      "2" => "fevereiro",
      "3" => "março",
      "4" => "abril",
      "5" => "maio",
      "6" => "junho",
      "7" => "julho",
      "8" => "agosto",
      "9" => "setembro",
      "10" => "outubro",
      "11" => "novembro",
      "12" => "dezembro"
    }

    raw_line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, &String.downcase/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> List.update_at(3, &integer_to_months[&1])
    |> List.update_at(4, &String.to_integer/1)
  end
end
