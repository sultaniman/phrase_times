defmodule PhraseTimezonesWeb.TimezonesFixtures do
  alias PhraseTimezones.Repo
  alias PhraseTimezones.Schemas.{City, MyTimezone}
  alias PhraseTimezones.Cities

  def prepare_timezones do
    city_names =
      TzExtra.time_zone_identifiers()
      |> Enum.take(10)
      |> Enum.map(fn tz_name ->
        city_name = tz_name |> String.split("/") |> Enum.at(1)

        Repo.insert!(%City{
          city_name: city_name,
          tz: tz_name
        })

        city_name
      end)

    city_names
    |> Enum.map(fn city_name ->
      city =
        city_name
        |> Cities.find_by_name()
        |> Enum.at(0)

      Repo.insert!(MyTimezone.changeset(%MyTimezone{}, %{city_id: city.id}))
    end)
  end
end
