defmodule PhraseTimes.Timezones do
  @moduledoc false
  use Agent
  @mod __MODULE__

  def start_link(_) do
    Agent.start_link(
      fn -> TzExtra.countries_time_zones() end,
      name: @mod
    )
  end

  def lookup(city_name) do
    @mod
    |> Agent.get(& &1)
    |> Enum.filter(fn tz_name ->
      tz_name
      |> String.downcase()
      |> String.contains?(String.downcase(city_name))
    end)
  end
end
