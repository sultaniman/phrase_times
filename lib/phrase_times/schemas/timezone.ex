defmodule PhraseTimes.Schemas.MyTimezone do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhraseTimes.Schemas.City

  schema "my_timezones" do
    field :tz, :string
    belongs_to :city, City
  end

  @doc false
  def changeset(timezone, attrs) do
    timezone
    |> cast(attrs, [:tz])
    |> validate_required([:tz])
  end
end
