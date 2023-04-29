defmodule PhraseTimezonesWeb.Components.MyTimezoneItem do
  @moduledoc false
  use PhraseTimezonesWeb, :live_component

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <li class="p-4 relative">
      <h4 class="text-lg font-medium leading-loose"><%= @city_name %></h4>
      <p class="text-gray-500">
        <%= @tz %>
        <span class="rounded-sm bg-blue-300 px-1 text-blue-800"><%= @now %></span>
      </p>
      <.close_button phx-click="on_delete" phx-target={@myself}>❌</.close_button>
    </li>
    """
  end

  @impl true
  def handle_event("on_delete", _params, socket) do
    id =
      socket.assigns.id
      |> String.split("#")
      |> Enum.at(1)
      |> Integer.parse()
      |> Tuple.to_list()
      |> Enum.at(0)

    send(self(), {:delete_timezone, id})
    {:noreply, socket}
  end
end
