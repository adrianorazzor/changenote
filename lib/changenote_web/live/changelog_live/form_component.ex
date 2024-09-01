defmodule ChangenoteWeb.ChangelogLive.FormComponent do
  use ChangenoteWeb, :live_component

  alias Changenote.Changelogs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage changelog records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="changelog-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:system_version]} type="text" label="System version" />
        <.input field={@form[:release_date]} type="date" label="Release date" />
        <.input field={@form[:bug_fixes]} type="text" label="Bug fixes" />
        <.input field={@form[:new_features]} type="text" label="New features" />
        <.input field={@form[:improvements]} type="text" label="Improvements" />
        <.input field={@form[:known_issues]} type="text" label="Known issues" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Changelog</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{changelog: changelog} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Changelogs.change_changelog(changelog))
     end)}
  end

  @impl true
  def handle_event("validate", %{"changelog" => changelog_params}, socket) do
    changeset = Changelogs.change_changelog(socket.assigns.changelog, changelog_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"changelog" => changelog_params}, socket) do
    save_changelog(socket, socket.assigns.action, changelog_params)
  end

  defp save_changelog(socket, :edit, changelog_params) do
    case Changelogs.update_changelog(socket.assigns.changelog, changelog_params) do
      {:ok, changelog} ->
        notify_parent({:saved, changelog})

        {:noreply,
         socket
         |> put_flash(:info, "Changelog updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_changelog(socket, :new, changelog_params) do
    case Changelogs.create_changelog(changelog_params) do
      {:ok, changelog} ->
        notify_parent({:saved, changelog})

        {:noreply,
         socket
         |> put_flash(:info, "Changelog created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
