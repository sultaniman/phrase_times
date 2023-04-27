alias PhraseTimes.Repo
alias PhraseTimes.Schemas.{City, MyTimezone}

cities_with_timezones =
  [
  "Europe/Andorra", "Europe/Astrakhan", "Europe/Athens", "Europe/Belgrade", "Europe/Berlin",
  "Europe/Brussels", "Europe/Bucharest", "Europe/Budapest", "Europe/Chisinau", "Europe/Dublin",
  "Europe/Gibraltar", "Europe/Helsinki", "Europe/Istanbul", "Europe/Kaliningrad", "Europe/Kirov",
  "Europe/Kyiv", "Europe/Lisbon", "Europe/London", "Europe/Madrid", "Europe/Malta", "Europe/Minsk",
  "Europe/Moscow", "Europe/Paris", "Europe/Prague", "Europe/Riga", "Europe/Rome", "Europe/Samara",
  "Europe/Saratov", "Europe/Simferopol", "Europe/Sofia", "Europe/Tallinn", "Europe/Tirane",
  "Europe/Ulyanovsk", "Europe/Vienna", "Europe/Vilnius", "Europe/Volgograd", "Europe/Warsaw",
  "Europe/Zurich", "Asia/Almaty", "Asia/Amman", "Asia/Anadyr", "Asia/Aqtau", "Asia/Aqtobe", "Asia/Ashgabat",
  "Asia/Atyrau", "Asia/Baghdad", "Asia/Baku", "Asia/Bangkok", "Asia/Barnaul", "Asia/Beirut",
  "Asia/Bishkek", "Asia/Chita", "Asia/Choibalsan", "Asia/Colombo", "Asia/Damascus", "Asia/Dhaka",
  "Asia/Dili", "Asia/Dubai", "Asia/Dushanbe", "Asia/Famagusta", "Asia/Gaza", "Asia/Hebron",
  "Asia/Ho_Chi_Minh", "Asia/Hong_Kong", "Asia/Hovd", "Asia/Irkutsk", "Asia/Jakarta", "Asia/Jayapura",
  "Asia/Jerusalem", "Asia/Kabul", "Asia/Kamchatka", "Asia/Karachi", "Asia/Kathmandu",
  "Asia/Khandyga", "Asia/Kolkata", "Asia/Krasnoyarsk", "Asia/Kuching", "Asia/Macau", "Asia/Magadan",
  "Asia/Makassar", "Asia/Manila", "Asia/Nicosia", "Asia/Novokuznetsk", "Asia/Novosibirsk",
  "Asia/Omsk", "Asia/Oral", "Asia/Pontianak"
  ]
  |> Enum.map(fn tz_name ->
    %{
      city_name: tz_name |> String.split("/") |> Enum.at(1),
      tz: tz_name
    }
  end)

Repo.transaction(fn ->
  Repo.insert_all(City, cities_with_timezones)
end)

Repo.insert! MyTimezone.changeset(%MyTimezone{}, %{city_id: 5})   # Select Berlin
Repo.insert! MyTimezone.changeset(%MyTimezone{}, %{city_id: 10})  # Select Dublin
