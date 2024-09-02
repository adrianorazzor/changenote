defmodule ChangenoteWeb.ChangelogLive.FormComponent do
  use ChangenoteWeb, :live_component
  alias Changenote.Changelogs
  alias Changenote.Changelogs.Changelog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="changelog-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:system_version]} type="text" label="System Version" />
        <.input field={@form[:release_date]} type="date" label="Release Date" />
        <.input field={@form[:bug_fixes]} type="textarea" label="Bug Fixes" />
        <.input field={@form[:new_features]} type="textarea" label="New Features" />
        <.input field={@form[:improvements]} type="textarea" label="Improvements" />
        <.input field={@form[:known_issues]} type="textarea" label="Known Issues" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Changelog</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{action: :new} = assigns, socket) do
    changeset = Changelogs.change_changelog(%Changelog{})
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"changelog" => changelog_params}, socket) do
    changelog_params = Map.update(changelog_params, "release_date", nil, &parse_date/1)

    case Changelogs.create_changelog(changelog_params) do
      {:ok, _changelog} ->
        send(self(), {__MODULE__, :changelog_created})
        {:noreply,
         socket
         |> put_flash(:info, "Changelog created successfully")}

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
