defmodule PhraseTimezones.Repo do
  use Ecto.Repo,
    otp_app: :phrase_timezones,
    adapter: Ecto.Adapters.Postgres
end
