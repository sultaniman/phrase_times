defmodule PhraseTimezonesWeb.Components.SuggestTimezone do
  @moduledoc false
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <form class="p-4 relative">
      <h4 class="text-lg font-medium leading-loose"><%= @city_name %></h4>
      <p class="text-gray-500"><%= @tz %></p>
    </form>
    """
  end

  def handle_event("on_delete", _params, socket) do
    send(self(), {:delete_timezone, socket.assigns.id})
    {:noreply, socket}
  end
end
