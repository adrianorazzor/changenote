defmodule ChangenoteWeb.ChangelogLive.Index do
  use ChangenoteWeb, :live_view

  alias Changenote.Changelogs
  alias Changenote.Changelogs.Changelog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :changelogs, Changelogs.list_changelogs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Changelog")
    |> assign(:changelog, Changelogs.get_changelog!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Changelog")
    |> assign(:changelog, %Changelog{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Changelogs")
    |> assign(:changelog, nil)
  end

  @impl true
  def handle_info({ChangenoteWeb.ChangelogLive.FormComponent, {:saved, changelog}}, socket) do
    {:noreply, stream_insert(socket, :changelogs, changelog)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    changelog = Changelogs.get_changelog!(id)
    {:ok, _} = Changelogs.delete_changelog(changelog)

    {:noreply, stream_delete(socket, :changelogs, changelog)}
  end
end
