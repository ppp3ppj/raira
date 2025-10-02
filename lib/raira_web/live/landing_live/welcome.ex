defmodule RairaWeb.LandingLive.Welcome do
  use RairaWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <p>Hello</p>
    """
  end
end
