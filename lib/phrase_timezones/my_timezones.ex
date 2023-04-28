defmodule PhraseTimezones.MyTimezones do
  @moduledoc false
  import Ecto.Query, warn: false
  alias PhraseTimezones.Repo
  alias PhraseTimezones.Schemas.MyTimezone

  def get_timezones() do
    MyTimezone
    |> Repo.all()
    |> Repo.preload(:city)
  end

  def add_timezone(city_id) do
    tz =
      %MyTimezone{}
      |> MyTimezone.changeset(%{city_id: city_id})
      |> Repo.insert!()

    Repo.one(from t in MyTimezone, where: t.id == ^tz.id)
    |> Repo.preload(:city)
  end

  def delete_timezone(timezone_id) do
    Repo.delete(%MyTimezone{id: timezone_id})
  end
end
