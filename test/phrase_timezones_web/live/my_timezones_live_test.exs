defmodule PhraseTimezonesWeb.MyTimezoneLiveTest do
  use PhraseTimezonesWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhraseTimezonesWeb.TimezonesFixtures

  defp create_my_timezone(_) do
    prepare_timezones()
    :ok
  end

  describe "Live::My Timezones" do
    setup [:create_my_timezone]

    test "lists my_timezones", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/timezones")

      assert html =~ "Enter time (Server time in UTC)"
    end
  end
end
