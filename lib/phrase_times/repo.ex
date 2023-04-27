defmodule PhraseTimes.Repo do
  use Ecto.Repo,
    otp_app: :phrase_times,
    adapter: Ecto.Adapters.Postgres
end
