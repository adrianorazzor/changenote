defmodule Changenote.Changelogs.Changelog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "changelogs" do
    field :system_version, :string
    field :title, :string
    field :content, :string
    field :release_date, :date
    field :bug_fixes, :string
    field :new_features, :string
    field :improvements, :string
    field :known_issues, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(changelog, attrs) do
    changelog
    |> cast(attrs, [:title, :content, :system_version, :release_date, :bug_fixes, :new_features, :improvements, :known_issues])
    |> validate_required([:title, :content, :system_version, :release_date, :bug_fixes, :new_features, :improvements, :known_issues])
  end
end
