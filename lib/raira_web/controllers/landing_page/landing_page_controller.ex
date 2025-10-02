defmodule RairaWeb.LandingPage.LandingPageController do
  @moduledoc false
  use RairaWeb, :controller

  @doc false
  def home(conn, _params) do
    render(conn, :landing_page)
  end
end
