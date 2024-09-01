defmodule Changenote.Repo do
  use Ecto.Repo,
    otp_app: :changenote,
    adapter: Ecto.Adapters.Postgres
end
