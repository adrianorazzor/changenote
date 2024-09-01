defmodule ChangenoteWeb.ChangelogLive.FormComponent do
  use ChangenoteWeb, :live_component
  alias Changenote.Changelogs

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="save" phx-target={@myself}>
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.button type="submit">Save Changelog</.button>
      </.form>
    </div>
    """
  end

  def update(%{action: :new} = _assigns, socket) do
    changeset = Changelogs.change_changelog(%Changelogs.Changelog{})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"changelog" => changelog_params}, socket) do
    case Changelogs.create_changelog(changelog_params) do
      {:ok, _changelog} ->
        send(self(), {__MODULE__, :changelog_created})
        {:noreply, socket |> put_flash(:info, "Changelog created successfully")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
