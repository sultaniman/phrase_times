defmodule PhraseTimes.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :city_name, :string
      add :tz, :string
    end

    create unique_index(:cities, [:city_name, :tz], name: :ix_city_name_tz)
  end
end
