defmodule PhraseTimezonesWeb.TimesLive do
  alias PhraseTimezones.Cities
  use PhraseTimezonesWeb, :live_view
  alias PhraseTimezones.Schemas.City
  alias PhraseTimezones.MyTimezones
  alias PhraseTimezonesWeb.Components.{AddTimezone, MyTimezone}
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
      |> assign(:auto_update, true)
    }
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="bg-transparent">
      <.header>
        Your timezones
      </.header>
      <div class="max-w-lg">
        <ul class="divide-y divide-gray-200 rounded-xl border border-gray-200 shadow-sm">
          <%= for timezone <- @timezones do %>
            <.live_component
              module={MyTimezone}
              city_name={timezone.city.city_name}
              tz={timezone.city.tz}
              now={timezone.current_time}
              id={"tz##{timezone.id}"}
            />
          <% end %>
        </ul>
      </div>
      <.live_component
        module={AddTimezone}
        suggestions={@suggestions}
        id="add-timezone"
      />
    </div>
    """
  end

  @impl true
  def handle_info({:delete_timezone, id}, socket) do
    id =
      id
      |> String.split("#")
      |> Enum.at(1)
      |> Integer.parse()
      |> Tuple.to_list()
      |> Enum.at(0)

    MyTimezones.delete_timezone(id)

    filtered_timezones =
      socket.assigns.timezones
      |> Enum.filter(fn tz -> tz.id != id end)

    {
      :noreply,
      socket
      |> assign(:timezones, filtered_timezones)
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
    exists = socket.assigns.timezones |> Enum.find(fn tz -> tz.city_id == city_id end)
    if exists do
      {:noreply, socket |> assign(:suggestions, [])}
    else
      new_timezone = MyTimezones.add_timezone(city_id)
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
    filtered_timezones =
      socket.assigns.timezones
      |> Enum.map(fn tz ->
        %{tz | current_time: now_in(tz.city)}
      end)

      :timer.send_after(@ticker_update_interval, self(), :tick)
    {
      :noreply,
      socket
      |> assign(:timezones, filtered_timezones)
    }
  end

  def now_in(%City{} = city) do
    city.tz
    |> DateTime.now!()
    |> Calendar.strftime("%I:%M:%S %p")
  end
end
