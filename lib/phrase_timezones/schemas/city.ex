defmodule PhraseTimezones.Schemas.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :city_name, :string
    field :tz, :string
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:city_name, :tz])
    |> validate_required([:city_name, :tz])
  end
end
