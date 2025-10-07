defmodule RairaWeb.ProjectTestLive do
  alias RairaWeb.LayoutComponents
  use RairaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns |> IO.inspect(label: "TEST")
    {:ok, assign(socket, self_path: ~p"/", page_title: "Project test")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.drawer_layout current_page={~p"/"} current_user={@current_scope.user}>
      <div class="p-4 md:px-12 md:py-6 max-w-screen-lg mx-auto">
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="Project" />
          <p>TEST</p>
        </div>
      </div>
    </LayoutComponents.drawer_layout>
    """
  end
end
