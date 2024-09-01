defmodule ChangenoteWeb.ChangelogLiveTest do
  use ChangenoteWeb.ConnCase

  import Phoenix.LiveViewTest
  import Changenote.ChangelogsFixtures

  @create_attrs %{system_version: "some system_version", title: "some title", content: "some content", release_date: "2024-08-31", bug_fixes: "some bug_fixes", new_features: "some new_features", improvements: "some improvements", known_issues: "some known_issues"}
  @update_attrs %{system_version: "some updated system_version", title: "some updated title", content: "some updated content", release_date: "2024-09-01", bug_fixes: "some updated bug_fixes", new_features: "some updated new_features", improvements: "some updated improvements", known_issues: "some updated known_issues"}
  @invalid_attrs %{system_version: nil, title: nil, content: nil, release_date: nil, bug_fixes: nil, new_features: nil, improvements: nil, known_issues: nil}

  defp create_changelog(_) do
    changelog = changelog_fixture()
    %{changelog: changelog}
  end

  describe "Index" do
    setup [:create_changelog]

    test "lists all changelogs", %{conn: conn, changelog: changelog} do
      {:ok, _index_live, html} = live(conn, ~p"/changelogs")

      assert html =~ "Listing Changelogs"
      assert html =~ changelog.system_version
    end

    test "saves new changelog", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/changelogs")

      assert index_live |> element("a", "New Changelog") |> render_click() =~
               "New Changelog"

      assert_patch(index_live, ~p"/changelogs/new")

      assert index_live
             |> form("#changelog-form", changelog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#changelog-form", changelog: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/changelogs")

      html = render(index_live)
      assert html =~ "Changelog created successfully"
      assert html =~ "some system_version"
    end

    test "updates changelog in listing", %{conn: conn, changelog: changelog} do
      {:ok, index_live, _html} = live(conn, ~p"/changelogs")

      assert index_live |> element("#changelogs-#{changelog.id} a", "Edit") |> render_click() =~
               "Edit Changelog"

      assert_patch(index_live, ~p"/changelogs/#{changelog}/edit")

      assert index_live
             |> form("#changelog-form", changelog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#changelog-form", changelog: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/changelogs")

      html = render(index_live)
      assert html =~ "Changelog updated successfully"
      assert html =~ "some updated system_version"
    end

    test "deletes changelog in listing", %{conn: conn, changelog: changelog} do
      {:ok, index_live, _html} = live(conn, ~p"/changelogs")

      assert index_live |> element("#changelogs-#{changelog.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#changelogs-#{changelog.id}")
    end
  end

  describe "Show" do
    setup [:create_changelog]

    test "displays changelog", %{conn: conn, changelog: changelog} do
      {:ok, _show_live, html} = live(conn, ~p"/changelogs/#{changelog}")

      assert html =~ "Show Changelog"
      assert html =~ changelog.system_version
    end

    test "updates changelog within modal", %{conn: conn, changelog: changelog} do
      {:ok, show_live, _html} = live(conn, ~p"/changelogs/#{changelog}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Changelog"

      assert_patch(show_live, ~p"/changelogs/#{changelog}/show/edit")

      assert show_live
             |> form("#changelog-form", changelog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#changelog-form", changelog: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/changelogs/#{changelog}")

      html = render(show_live)
      assert html =~ "Changelog updated successfully"
      assert html =~ "some updated system_version"
    end
  end
end
