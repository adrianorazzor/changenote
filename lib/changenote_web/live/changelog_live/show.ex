defmodule ChangenoteWeb.ChangelogLive.Show do
  use ChangenoteWeb, :live_view

  alias Changenote.Changelogs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:changelog, Changelogs.get_changelog!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    changelog = Changelogs.get_changelog!(id)
    {:ok, _} = Changelogs.delete_changelog(changelog)

    {:noreply,
     socket
     |> put_flash(:info, "Changelog deleted successfully")
     |> push_navigate(to: ~p"/changelogs")}
  end

  defp page_title(:show), do: "Show Changelog"
  defp page_title(:edit), do: "Edit Changelog"
end
