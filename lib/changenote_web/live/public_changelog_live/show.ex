defmodule ChangenoteWeb.PublicChangelogLive.Show do
  use ChangenoteWeb, :live_view

  alias Changenote.Changelogs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    changelog = Changelogs.get_changelog!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Changelog: #{changelog.title}")
     |> assign(:changelog, changelog)}
  end
end
