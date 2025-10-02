defmodule RairaWeb.SettingsLive do
  alias RairaWeb.LayoutComponents
  use RairaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, self_path: ~p"/", page_title: "Settings")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.layout current_page={~p"/settings"}>
      <p>Settings</p>
    </LayoutComponents.layout>
    """
  end
end
