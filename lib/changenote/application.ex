defmodule Changenote.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChangenoteWeb.Telemetry,
      Changenote.Repo,
      {DNSCluster, query: Application.get_env(:changenote, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Changenote.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Changenote.Finch},
      # Start a worker by calling: Changenote.Worker.start_link(arg)
      # {Changenote.Worker, arg},
      # Start to serve requests, typically the last entry
      ChangenoteWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Changenote.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChangenoteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
