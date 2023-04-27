defmodule PhraseTimes.Schemas.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :name, :string
    field :tz, :string
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :tz])
    |> validate_required([:name, :tz])
  end
end
