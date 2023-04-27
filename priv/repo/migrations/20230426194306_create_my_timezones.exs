defmodule PhraseTimes.Repo.Migrations.CreateMyTimezones do
  use Ecto.Migration

  def change do
    create table(:my_timezones) do
      add :city_name, :string
      add :city_id, references(:cities)
    end

    create unique_index(:my_timezones, [:city_id])
  end
end
