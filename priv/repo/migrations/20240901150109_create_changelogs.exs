defmodule Changenote.Repo.Migrations.CreateChangelogs do
  use Ecto.Migration

  def change do
    create table(:changelogs) do
      add :title, :string
      add :content, :text
      add :system_version, :string
      add :release_date, :date
      add :bug_fixes, :text
      add :new_features, :text
      add :improvements, :text
      add :known_issues, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:changelogs, [:user_id])
  end
end
