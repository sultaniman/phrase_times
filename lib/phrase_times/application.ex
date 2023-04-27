defmodule PhraseTimes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PhraseTimesWeb.Telemetry,
      # Start the Ecto repository
      PhraseTimes.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhraseTimes.PubSub},
      # Start Finch
      {Finch, name: PhraseTimes.Finch},
      # Start the Endpoint (http/https)
      PhraseTimesWeb.Endpoint
      # Start a worker by calling: PhraseTimes.Worker.start_link(arg)
      # {PhraseTimes.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhraseTimes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhraseTimesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
