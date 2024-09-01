defmodule Changenote.ChangelogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Changenote.Changelogs` context.
  """

  @doc """
  Generate a changelog.
  """
  def changelog_fixture(attrs \\ %{}) do
    {:ok, changelog} =
      attrs
      |> Enum.into(%{
        bug_fixes: "some bug_fixes",
        content: "some content",
        improvements: "some improvements",
        known_issues: "some known_issues",
        new_features: "some new_features",
        release_date: ~D[2024-08-31],
        system_version: "some system_version",
        title: "some title"
      })
      |> Changenote.Changelogs.create_changelog()

    changelog
  end
end
