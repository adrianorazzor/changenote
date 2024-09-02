defmodule ChangenoteWeb.ChangelogLive.New do
  use ChangenoteWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_info({ChangenoteWeb.ChangelogLive.FormComponent, :changelog_created}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Changelog created successfully")
     |> push_navigate(to: ~p"/changelogs")}
  end
end
