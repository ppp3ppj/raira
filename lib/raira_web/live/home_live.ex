defmodule RairaWeb.HomeLive do
  use RairaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, self_path: ~p"/")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p>ppp</p>
    """
  end
end
