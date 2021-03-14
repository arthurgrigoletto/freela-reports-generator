defmodule FreelaReportsGenerator do
  alias FreelaReportsGenerator.Parser

  @avaliable_names [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "danilo",
    "rafael",
    "vinicius"
  ]

  @avaliable_months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @avaliable_years [
    "2016",
    "2017",
    "2018",
    "2019",
    "2020"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  defp sum_values([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    month = Enum.at(@avaliable_months, month - 1)
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month =
      Map.put(hours_per_month, name, %{
        hours_per_month[name]
        | month => hours_per_month[name][month] + hours
      })

    hours_per_year =
      Map.put(hours_per_year, name, %{
        hours_per_year[name]
        | year => hours_per_year[name][year] + hours
      })

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp report_acc do
    all_hours = Enum.into(@avaliable_names, %{}, &{String.downcase(&1), 0})
    months = Enum.into(@avaliable_months, %{}, &{String.downcase(&1), 0})
    years = Enum.into(@avaliable_years, %{}, &{String.downcase(&1), 0})
    hours_per_month = Enum.into(@avaliable_names, %{}, &{String.downcase(&1), months})
    hours_per_year = Enum.into(@avaliable_names, %{}, &{String.downcase(&1), years})

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
