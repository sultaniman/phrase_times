defmodule PhraseTimezones.TimezonesLogic do
  @moduledoc false
  alias PhraseTimezones.MyTimezones
  alias PhraseTimezones.Schemas.City

  def exclude_timezone(timezones, timezone_id) do
    Enum.filter(
      timezones,
      fn tz -> tz.id != timezone_id end
    )
  end

  def has_timezone?(timezones, city_id) do
    not (timezones
         |> Enum.find(fn tz -> tz.city_id == city_id end)
         |> is_nil())
  end

  def add_city(timezones, converter_mode, city_id) do
    new_timezone = MyTimezones.add_timezone(city_id)

    if converter_mode do
      time =
        timezones
        |> Enum.at(0)
        |> Map.get(:city)
        |> Map.get(:tz)
        |> DateTime.now!()
        |> DateTime.shift_zone!(new_timezone.city.tz)
        |> Calendar.strftime("%I:%M:%S %p")

      %{new_timezone | current_time: time}
    else
      new_timezone
    end
  end

  def update_current_times(timezones) do
    timezones
    |> Enum.map(fn tz ->
      %{tz | current_time: now_in(tz.city)}
    end)
  end

  def shift_current_times(timezones, relative_to_time) do
    timezones
    |> Enum.map(fn tz ->
      converted =
        relative_to_time
        |> DateTime.shift_zone!(tz.city.tz)
        |> Calendar.strftime("%I:%M:%S %p")

      %{tz | current_time: converted}
    end)
  end

  def now_in(%City{} = city) do
    city.tz
    |> DateTime.now!()
    |> Calendar.strftime("%I:%M:%S %p")
  end

  def utc_now() do
    DateTime.utc_now()
    |> Calendar.strftime("%I:%M:%S")
  end
end
