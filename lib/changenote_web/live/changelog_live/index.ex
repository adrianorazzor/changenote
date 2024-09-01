defmodule ChangenoteWeb.ChangelogLive.Index do
  use ChangenoteWeb, :live_view
  alias Changenote.Changelogs

  @impl true
  def mount(_params, _session, socket) do
    changelogs = Changelogs.list_changelogs()
    socket = assign(socket, :changelogs, changelogs)
    {:ok, assign(socket, changelogs: changelogs)}
  end
end
