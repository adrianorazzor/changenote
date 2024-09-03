defmodule ChangenoteWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use ChangenoteWeb, :controller` and
  `use ChangenoteWeb, :live_view`.
  """
  use ChangenoteWeb, :html

  def app_version do
    Application.spec(:changenote, :vsn) |> to_string()
  end

  embed_templates "layouts/*"
end
