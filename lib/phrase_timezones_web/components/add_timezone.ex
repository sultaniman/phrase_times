defmodule PhraseTimezonesWeb.Components.AddTimezone do
  @moduledoc false
  use PhraseTimezonesWeb, :live_component
  @min_lookup_chars 3

  def render(assigns) do
    ~H"""
    <div>
      <form class="mt-10" phx-change="search" phx-submit="search" phx-target={@myself}>
        <input
          type="text"
          name="city_name"
          value={@city_name}
          placeholder="Find city///"
          class="w-[76%] rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-400 focus:ring-opacity-50 "
        />
      </form>
      <%= if length(@suggestions) > 0 do %>
        <.suggestion_list items={@suggestions} myself={@myself} />
      <% end %>
    </div>
    """
  end

  attr :items, :list
  attr :myself, :any

  def suggestion_list(assigns) do
    ~H"""
    <div class="w-[75%] ml-1 mt-2 p-1">
      <%= for city <- @items do %>
        <a
          phx-click="add_city"
          phx-target={@myself}
          phx-value-city-id={city.id}
          class="flex items-center px-4 py-3 -mx-2 rounded-md transition-colors duration-300 transform hover:bg-slate-50 dark:hover:bg-slate-300"
        >
          <p class="mx-2 text-sm text-gray-600">
            <span class="font-bold">
              <%= city.city_name %>
            </span>
            at <%= city.tz %>
            <span class="absolute right-2 top-[10px] button text-[32px]" title="Add city">+</span>
          </p>
        </a>
      <% end %>
    </div>
    """
  end

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:city_name, "")
    }
  end

  def handle_event("search", %{"city_name" => city_name}, socket) do
    if city_name |> String.length() >= @min_lookup_chars do
      send(self(), {:search_city, city_name})
    end

    {:noreply, socket}
  end

  def handle_event("add_city", %{"city-id" => city_id}, socket) do
    id =
      city_id
      |> Integer.parse()
      |> Tuple.to_list()
      |> Enum.at(0)

    send(self(), {:add_city, id})

    {:noreply, socket}
  end
end
