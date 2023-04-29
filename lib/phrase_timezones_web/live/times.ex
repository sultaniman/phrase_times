defmodule PhraseTimezonesWeb.TimesLive do
  alias PhraseTimezones.Cities
  use PhraseTimezonesWeb, :live_view
  alias PhraseTimezones.{MyTimezones, TimezonesLogic}
  alias PhraseTimezonesWeb.Components.{AddTimezone, MyTimezoneItem, TimeInput}
  @ticker_update_interval 1000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      send(self(), :tick)
    end

    {
      :ok,
      socket
      |> assign(:timezones, MyTimezones.get_timezones())
      |> assign(:suggestions, [])
      |> assign(:current_time, TimezonesLogic.utc_now())
      |> assign(:converter_mode, false)
    }
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="bg-transparent">
      <.live_component module={TimeInput} time={@current_time} id="select-time" />
      <.header>
        Your timezones
      </.header>
      <div class="max-w-lg">
        <ul class="divide-y divide-gray-200 rounded-xl border border-gray-200 shadow-sm">
          <%= for timezone <- @timezones do %>
            <.live_component
              module={MyTimezoneItem}
              city_name={timezone.city.city_name}
              tz={timezone.city.tz}
              now={timezone.current_time}
              id={"tz##{timezone.id}"}
            />
          <% end %>
        </ul>
      </div>
      <.live_component module={AddTimezone} suggestions={@suggestions} id="add-timezone" />
    </div>
    """
  end

  @impl true
  def handle_info({:delete_timezone, id}, socket) do
    MyTimezones.delete_timezone(id)

    timezones =
      socket.assigns.timezones
      |> TimezonesLogic.exclude_timezone(id)

    {
      :noreply,
      socket
      |> assign(:timezones, timezones)
    }
  end

  @impl true
  def handle_info({:search_city, city_name}, socket) do
    {
      :noreply,
      socket
      |> assign(:suggestions, Cities.find_by_name(city_name))
    }
  end

  @impl true
  def handle_info({:add_city, city_id}, socket) do
    # We want to prevent addind a timezone
    # if it already exists in liveview state
    if TimezonesLogic.has_timezone?(socket.assigns.timezones, city_id) do
      {:noreply, socket |> assign(:suggestions, [])}
    else
      new_timezone =
        socket.assigns.timezones
        |> TimezonesLogic.add_city(socket.assigns.converter_mode, city_id)

      {
        :noreply,
        socket
        |> assign(:suggestions, [])
        |> assign(:timezones, socket.assigns.timezones ++ [new_timezone])
      }
    end
  end

  @impl true
  def handle_info(:tick, socket) do
    if socket.assigns.converter_mode do
      {:noreply, socket}
    else
      filtered_timezones =
        socket.assigns.timezones
        |> TimezonesLogic.update_current_times()

      :timer.send_after(@ticker_update_interval, self(), :tick)

      {
        :noreply,
        socket
        |> assign(:current_time, TimezonesLogic.utc_now())
        |> assign(:timezones, filtered_timezones)
      }
    end
  end

  @impl true
  def handle_info({:time_selected, time}, socket) do
    timezones_with_time =
      socket.assigns.timezones
      |> TimezonesLogic.shift_current_times(time)

    {
      :noreply,
      socket
      |> assign(:converter_mode, true)
      |> assign(:timezones, timezones_with_time)
    }
  end

  @impl true
  def handle_info(:reset_and_resume, socket) do
    if socket.assigns.converter_mode do
      :timer.send_after(@ticker_update_interval, self(), :tick)

      {
        :noreply,
        socket
        |> assign(:converter_mode, false)
      }
    else
      {:noreply, socket}
    end
  end
end
