defmodule PhraseTimezonesWeb.Components.TimeInput do
  @moduledoc false
  use PhraseTimezonesWeb, :live_component
  @interval 1000

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="mb-5 relative">
      <.header>Enter time (Server time in UTC)</.header>
      <form class="mb-2" phx-change="select_time" phx-submit="select_time" phx-target={@myself}>
        <input
          type="time"
          name="time"
          value={@time}
          placeholder="Enter time to convert"
          class="w-[76%] rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-400 focus:ring-opacity-50 "
        />
      </form>
      <.button
        type="button"
        phx-click="use_current_time"
        phx-target={@myself}
        class="rounded-md bg-blue-400 text-blue-700 text-[16px] font-normal hover:bg-blue-900 hover:text-blue-400"
      >
        Use current time
      </.button>
    </div>
    """
  end

  @impl true
  def handle_event("select_time", %{"time" => time}, socket) do
    [hour, minute, second] =
      time
      |> String.split(":")
      |> Enum.map(fn number ->
        number
        |> Integer.parse()
        |> Tuple.to_list()
        |> Enum.at(0)
      end)

    now = DateTime.utc_now()
    now = %{now | hour: hour, minute: minute, second: second}
    send(self(), {:time_selected, now})

    {:noreply, socket}
  end

  @impl true
  def handle_event("use_current_time", _params, socket) do
    send(self(), :reset_and_resume)
    {:noreply, socket}
  end
end
