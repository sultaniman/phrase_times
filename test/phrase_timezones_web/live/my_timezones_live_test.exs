defmodule PhraseTimezonesWeb.MyTimezoneLiveTest do
  use PhraseTimezonesWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhraseTimezonesWeb.TimezonesFixtures

  alias PhraseTimezones.MyTimezones
  alias PhraseTimezones.Cities

  defp create_my_timezone(_) do
    prepare_timezones()
    :ok
  end

  describe "Live::My Timezones" do
    setup [:create_my_timezone]

    test "my_timezones shows up", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/timezones")

      assert html =~ "Enter time (Server time in UTC)"
      assert html =~ "Your timezones"

      send(view.pid, {:search_city, "cairo"})
      assert view |> element("#timezone-suggestions") |> has_element?()
    end

    test "lists my_timezones works", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/timezones")

      items =
        html
        |> Floki.parse_document!()
        |> Floki.find(".timezone-item")

      assert length(items) == 10
    end

    test "delete timezones works", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/timezones")

      items =
        html
        |> Floki.parse_document!()
        |> Floki.find(".delete-timezone")

      item1 =
        items
        |> Enum.at(0)
        |> Floki.attribute("id")

      item2 =
        items
        |> Enum.at(1)
        |> Floki.attribute("id")

      assert view
             |> element("##{item1}")
             |> render_click()

      assert view
             |> element("##{item2}")
             |> render_click()

      {:ok, _view, html} = live(conn, ~p"/timezones")

      items =
        html
        |> Floki.parse_document!()
        |> Floki.find(".timezone-item")

      assert length(items) == 8
    end

    test "it prevents adding the same timezone again", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/timezones")
      # we have added Cairo during setup
      city = Cities.find_by_name("cairo") |> Enum.at(0)
      send(view.pid, {:add_city, city.id})
      {:ok, updated_view, _html} = live(conn, ~p"/timezones")

      items =
        updated_view
        |> render()
        |> Floki.parse_document!()
        |> Floki.find(".timezone-item")

      assert length(items) == 10
    end

    test "adding timezone works", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/timezones")
      # we have added Cairo during setup
      city = Cities.find_by_name("Windhoek") |> Enum.at(0)
      send(view.pid, {:add_city, city.id})
      {:ok, _view, html} = live(conn, ~p"/timezones")

      items =
        html
        |> Floki.parse_document!()
        |> Floki.find(".timezone-item")

      assert length(MyTimezones.get_timezones()) == 11
      assert length(items) == 11
    end
  end
end
