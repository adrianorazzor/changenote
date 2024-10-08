defmodule Changenote.Changelogs.Changelog do
  @moduledoc """
  Manages changelog entries for the Changenote application.

  This module defines the schema for changelog entries, including fields for
  system version, title, description, release date, bug fixes, new features,
  improvements, known issues, and the associated user. It also provides methods
  for creating and validating changelog entries.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Changenote.Accounts.User

  schema "changelogs" do
    field :system_version, :string
    field :title, :string
    # Changed from :content to :description
    field :description, :string
    field :release_date, :date
    field :bug_fixes, :string
    field :new_features, :string
    field :improvements, :string
    field :known_issues, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(changelog, attrs) do
    changelog
    |> cast(attrs, [
      :title,
      :description,
      :system_version,
      :release_date,
      :bug_fixes,
      :new_features,
      :improvements,
      :known_issues
    ])
    |> validate_required([
      :title,
      :description,
      :system_version,
      :release_date,
      :bug_fixes,
      :new_features,
      :improvements,
      :known_issues
    ])
  end
end
