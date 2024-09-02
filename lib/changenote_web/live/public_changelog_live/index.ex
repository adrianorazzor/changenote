defmodule ChangenoteWeb.PublicChangelogLive.Index do
  use ChangenoteWeb, :live_view

  alias Changenote.Changelogs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :changelogs, list_changelogs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Public Changelogs")
  end

  # Add this new function to handle the button click
  @impl true
  def handle_event("view_details", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/public/changelogs/#{id}")}
  end

  defp list_changelogs do
    Changelogs.list_public_changelogs()
  end
end
