defmodule Changenote.Repo.Migrations.RenameContentToDescription do
  use Ecto.Migration

  def change do
    rename table(:changelogs), :content, to: :description
  end
end
