alias PhraseTimezones.Repo
alias PhraseTimezones.Schemas.{City, MyTimezone}


cities_with_timezones =
  TzExtra.time_zone_identifiers()
  |> Enum.map(fn tz_name ->
    %{
      city_name: tz_name |> String.split("/") |> Enum.at(1),
      tz: tz_name
    }
  end)

Repo.transaction(fn ->
  Repo.insert_all(City, cities_with_timezones)
end)

# Add first 5 cities to my timezones
for id <- 1..5 do
  Repo.insert! MyTimezone.changeset(%MyTimezone{}, %{city_id: id})
end
