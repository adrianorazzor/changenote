defmodule Changenote.Changelogs do
  @moduledoc """
  The Changelogs context.
  """

  import Ecto.Query, warn: false
  alias Changenote.Repo

  alias Changenote.Changelogs.Changelog


  def list_changelogs do
    Repo.all(Changelog)
  end

  def get_changelog!(id), do: Repo.get!(Changelog, id)

  def create_changelog(attrs \\ %{}, user) do
    %Changelog{}
    |> Changelog.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end


  def update_changelog(%Changelog{} = changelog, attrs) do
    changelog
    |> Changelog.changeset(attrs)
    |> Repo.update()
  end


  def delete_changelog(%Changelog{} = changelog) do
    Repo.delete(changelog)
  end


  def change_changelog(%Changelog{} = changelog, attrs \\ %{}) do
    Changelog.changeset(changelog, attrs)
  end

  def list_public_changelogs do
    Changelog
    |> order_by([c], desc: c.release_date, desc: c.inserted_at)
    # Limit to the 10 most recent changelogs
    |> limit(10)
    |> Repo.all()
  end
end
