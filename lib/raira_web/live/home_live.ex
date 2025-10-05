defmodule RairaWeb.HomeLive do
  alias RairaWeb.LayoutComponents
  use RairaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns |> IO.inspect(label: "TEST")
    {:ok, assign(socket, self_path: ~p"/", page_title: "Home")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.layout current_page={~p"/"} current_user={@current_scope.user} saved_hubs={[]}>
      <div class="p-4 md:px-12 md:py-6 max-w-screen-lg mx-auto">
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="Home" />
          <div class="hidden md:flex space-x-2" role="navigation" aria-label="new notebook">
            <.button color="gray" outlined navigate={~p"/open/storage"}>
              Open
            </.button>
            <.button color="blue" patch={~p"/new"}>
              <.icon name="hero-add-line" />
              <span>New notebook</span>
            </.button>
          </div>
        </div>
      </div>
    </LayoutComponents.layout>
    """
  end
end
