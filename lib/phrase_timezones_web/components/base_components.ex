defmodule PhraseTimezonesWeb.BaseComponents do
  @moduledoc false
  use Phoenix.Component
  alias DateTime

  @doc """
  Renders a close button.

  ## Examples

      <.close-button>Send!</.close-button>
      <.close-button phx-click="go" class="ml-2">Send!</.close-button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def close_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-bl-lg rounded-tr-xl",
        "absolute top-[1px] right-[1px] border border-transparent",
        "bg-gray-100 px-5 py-2.5 text-center text-sm font-medium text-gray-700 shadow-none transition-all hover:bg-red-100",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
