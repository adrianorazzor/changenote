defmodule ChangenoteWeb.ChangelogLive.FormComponent do
  use ChangenoteWeb, :live_component
  alias Changenote.Changelogs
  alias Changenote.Changelogs.Changelog
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="changelog-form" phx-target={@myself} phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:system_version]} type="text" label="System Version" />
        <.input field={@form[:release_date]} type="date" label="Release Date" />
        <.input field={@form[:bug_fixes]} type="textarea" label="Bug Fixes" />
        <.input field={@form[:new_features]} type="textarea" label="New Features" />
        <.input field={@form[:improvements]} type="textarea" label="Improvements" />
        <.input field={@form[:known_issues]} type="textarea" label="Known Issues" />
        <:actions>
          <div class="flex justify-center w-full">
            <.button phx-disable-with="Saving...">Save Changelog</.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changelog = get_changelog(assigns)
    changeset = Changelogs.change_changelog(changelog)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changelog, changelog)
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"changelog" => changelog_params}, socket) do
    changeset =
      socket.assigns.changelog
      |> Changelogs.change_changelog(changelog_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"changelog" => changelog_params}, socket) do
    save_changelog(socket, socket.assigns.action, changelog_params)
  end

  defp save_changelog(socket, :edit, changelog_params) do
    case Changelogs.update_changelog(socket.assigns.changelog, changelog_params) do
      {:ok, changelog} ->
        notify_parent({:changelog_updated, changelog})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_changelog(socket, :new, changelog_params) do
    case Changelogs.create_changelog(changelog_params, socket.assigns.current_user) do
      {:ok, changelog} ->
        notify_parent({:changelog_created, changelog})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp get_changelog(%{changelog: changelog}), do: changelog
  defp get_changelog(%{action: :new}), do: %Changelog{}
  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

end
