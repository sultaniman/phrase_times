defmodule PhraseTimezones.Cities do
  @moduledoc false
  import Ecto.Query, warn: false
  alias PhraseTimezones.Repo
  alias PhraseTimezones.Schemas.City

  def find_by_name(name) do
    like_name = "%#{name}%"
    Repo.all(from c in City, where: ilike(c.city_name, ^like_name))
  end
end
