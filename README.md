[![Elixir CI](https://github.com/sultaniman/phrase_times/actions/workflows/elixir.yml/badge.svg)](https://github.com/sultaniman/phrase_times/actions/workflows/elixir.yml)

# Time converter between timezones

A web application that converts entered time between chosen time zones.

## Configuration

Please configure Postgres credentials in [`dev.exs`](https://github.com/sultaniman/phrase_times/blob/main/config/dev.exs#L5)

## Running

1. Install dependencies `mix deps.get`,
2. Apply migrations `mix ecto.migrate`,
3. To have initial data in the app please seed database using `mix run priv/repo/seeds.exs`,
4. Running the server `mix.phx server`,
5. Open the following URL `http://localhost:4000/timezones` in your browser.

## Testing

To test please configure Postgres credentials in [`test.exs`](https://github.com/sultaniman/phrase_times/blob/main/config/test.exs#L9)
then run `mix test`.

## Short demo

https://user-images.githubusercontent.com/354868/235318134-ada87c09-ca40-45e6-989d-abd71bf60e67.mov
