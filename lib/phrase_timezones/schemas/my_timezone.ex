defmodule PhraseTimezones.Schemas.MyTimezone do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhraseTimezones.Schemas.City

  schema "my_timezones" do
    field :current_time, :string, virtual: true
    belongs_to :city, City
  end

  @doc false
  def changeset(timezone, attrs) do
    timezone
    |> cast(attrs, [:city_id])
    |> validate_required([:city_id])
    |> foreign_key_constraint(:city_id)
  end
end
