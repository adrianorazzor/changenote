defmodule Changenote.ChangelogsTest do
  use Changenote.DataCase

  alias Changenote.Changelogs

  describe "changelogs" do
    alias Changenote.Changelogs.Changelog

    import Changenote.ChangelogsFixtures

    @invalid_attrs %{
      system_version: nil,
      title: nil,
      content: nil,
      release_date: nil,
      bug_fixes: nil,
      new_features: nil,
      improvements: nil,
      known_issues: nil
    }

    test "list_changelogs/0 returns all changelogs" do
      changelog = changelog_fixture()
      assert Changelogs.list_changelogs() == [changelog]
    end

    test "get_changelog!/1 returns the changelog with given id" do
      changelog = changelog_fixture()
      assert Changelogs.get_changelog!(changelog.id) == changelog
    end

    test "create_changelog/1 with valid data creates a changelog" do
      valid_attrs = %{
        system_version: "some system_version",
        title: "some title",
        content: "some content",
        release_date: ~D[2024-08-31],
        bug_fixes: "some bug_fixes",
        new_features: "some new_features",
        improvements: "some improvements",
        known_issues: "some known_issues"
      }

      assert {:ok, %Changelog{} = changelog} = Changelogs.create_changelog(valid_attrs)
      assert changelog.system_version == "some system_version"
      assert changelog.title == "some title"
      assert changelog.content == "some content"
      assert changelog.release_date == ~D[2024-08-31]
      assert changelog.bug_fixes == "some bug_fixes"
      assert changelog.new_features == "some new_features"
      assert changelog.improvements == "some improvements"
      assert changelog.known_issues == "some known_issues"
    end

    test "create_changelog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Changelogs.create_changelog(@invalid_attrs)
    end

    test "update_changelog/2 with valid data updates the changelog" do
      changelog = changelog_fixture()

      update_attrs = %{
        system_version: "some updated system_version",
        title: "some updated title",
        content: "some updated content",
        release_date: ~D[2024-09-01],
        bug_fixes: "some updated bug_fixes",
        new_features: "some updated new_features",
        improvements: "some updated improvements",
        known_issues: "some updated known_issues"
      }

      assert {:ok, %Changelog{} = changelog} = Changelogs.update_changelog(changelog, update_attrs)
      assert changelog.system_version == "some updated system_version"
      assert changelog.title == "some updated title"
      assert changelog.content == "some updated content"
      assert changelog.release_date == ~D[2024-09-01]
      assert changelog.bug_fixes == "some updated bug_fixes"
      assert changelog.new_features == "some updated new_features"
      assert changelog.improvements == "some updated improvements"
      assert changelog.known_issues == "some updated known_issues"
    end

    test "update_changelog/2 with invalid data returns error changeset" do
      changelog = changelog_fixture()
      assert {:error, %Ecto.Changeset{}} = Changelogs.update_changelog(changelog, @invalid_attrs)
      assert changelog == Changelogs.get_changelog!(changelog.id)
    end

    test "delete_changelog/1 deletes the changelog" do
      changelog = changelog_fixture()
      assert {:ok, %Changelog{}} = Changelogs.delete_changelog(changelog)
      assert_raise Ecto.NoResultsError, fn -> Changelogs.get_changelog!(changelog.id) end
    end

    test "change_changelog/1 returns a changelog changeset" do
      changelog = changelog_fixture()
      assert %Ecto.Changeset{} = Changelogs.change_changelog(changelog)
    end
  end
end
