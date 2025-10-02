defmodule RairaWeb.HomeLive do
  alias RairaWeb.LayoutComponents
  use RairaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, self_path: ~p"/", page_title: "Home")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.layout current_page={~p"/"}>
      <p>Home</p>
    </LayoutComponents.layout>
    """
  end
end
