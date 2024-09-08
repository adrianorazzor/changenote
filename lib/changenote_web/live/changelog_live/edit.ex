defmodule ChangenoteWeb.ChangelogLive.Edit do
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
     |> assign(:page_title, "Edit Changelog")
     |> assign(:changelog, changelog)
     |> assign(:live_action, :edit)
     |> assign(:current_user, socket.assigns.current_user)}
  end

  @impl true
  def handle_info({ChangenoteWeb.ChangelogLive.FormComponent, {:changelog_updated, changelog}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Changelog updated successfully")
     |> push_navigate(to: ~p"/changelogs/#{changelog.id}")}
  end
end
