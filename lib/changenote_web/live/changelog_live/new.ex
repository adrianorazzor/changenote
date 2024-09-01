defmodule ChangenoteWeb.ChangelogLive.New do
  use ChangenoteWeb, :live_view

  alias Changenote.Changelogs
  alias Changenote.Changelogs.Changelog

  @impl true
  def mount(_params, _session, socket) do
    changeset = Changelogs.change_changelog(%Changelog{})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"changelog" => changelog_params}, socket) do
    # Convert the release_date from string to Date
    changelog_params = Map.update(changelog_params, "release_date", nil, &parse_date/1)

    case Changelogs.create_changelog(changelog_params) do
      {:ok, _changelog} ->
        {:noreply,
         socket
         |> put_flash(:info, "Changelog created successfully")
         |> push_navigate(to: ~p"/changelogs")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp parse_date(date_str) do
    case Date.from_iso8601(date_str) do
      {:ok, date} -> date
      {:error, _} -> nil
    end
  end
end
