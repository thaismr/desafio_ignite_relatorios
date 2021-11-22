defmodule GenReport do
  alias GenReport.Parser

  @freelancers [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]


  def build do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), &sum_hours/2)
  end

  defp report_acc() do
    months = Enum.into(Map.values(Parser.get_months), %{}, &{&1, 0})
    years = Enum.into(2016..2020, %{}, &{&1, 0})

    %{
      "all_hours" => Enum.into(@freelancers, %{}, &{&1, 0}),
      "hours_per_month" => Enum.into(@freelancers, %{}, &{&1, months}),
      "hours_per_year" => Enum.into(@freelancers, %{}, &{&1, years})
    }
  end

  defp sum_hours(
         [name, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
    user_monthly = Map.put(hours_per_month[name], month, hours_per_month[name][month] + hours)
    user_yearly = Map.put(hours_per_year[name], year, hours_per_year[name][year] + hours)

    %{
      "all_hours" => Map.put(all_hours, name, all_hours[name] + hours),
      "hours_per_month" => Map.put(hours_per_month, name, user_monthly),
      "hours_per_year" => Map.put(hours_per_year, name, user_yearly)
    }
  end
end
