defmodule ChangenoteWeb.ChangelogLive.New do
  use ChangenoteWeb, :live_view

  alias Changenote.Changelogs.Changelog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Changelog")
    |> assign(:changelog, %Changelog{})
  end

  @impl true
  def handle_info({ChangenoteWeb.ChangelogLive.FormComponent, {:changelog_created, changelog}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Changelog created successfully")
     |> push_navigate(to: ~p"/changelogs/#{changelog}")}
  end
end
