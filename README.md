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

https://user-images.githubusercontent.com/354868/235350801-45bd29a7-0306-46b4-9af6-df6c17b6ec6b.mov

## Structure

Live view `PhraseTimezonesWeb.TimesLive` consists of live components which live under `PhraseTimezonesWeb.Components`
some basic logic is offloaded from liveview to [utility module](https://github.com/sultaniman/phrase_times/blob/main/lib/phrase_timezones/timezones_logic.ex) in context app.
Ecto schemas and contexts are minimal to support only what is needed and to avoid boilerplate.

* `PhraseTimezonesWeb.Components` (top down order according to UI)
    * `TimeInput` - autocomplete suggestions,
    * `AddTimezone` - component with autocomplete to search and add new timezones,
    * `MyTimezoneItem` - list item component to display added timezones.

## Timezone database

When [seeding database ](https://github.com/sultaniman/phrase_times/blob/main/priv/repo/seeds.exs) [Tz](https://github.com/mathieuprog/tz) and [TzExtra](https://github.com/mathieuprog/tz) libraries
used to get timezones and to add initial cities with timezones.
