defmodule RairaWeb.HomeLive.ProjectListComponent do
  use RairaWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, order_by: "date")}
  end

  @impl true
  def update(socket) do
    {:ok, assign(socket, order_by: "date")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form id="bulk-action-form" phx-submit="bulk_action" phx-target={@myself}>
      <div class="mb-4 flex items-center md:items-end justify-between">
        <h2 class="uppercase font-semibold text-gray-500 text-sm md:text-base">
          Running projects ({length(@projects)})
        </h2>
      </div>
      <.session_list
        projects={@projects}
        myself={@myself}
      />
    </form>
    """
  end

  defp session_list(%{projects: []} = assigns) do
    ~H"""
    <.no_entries>
      You do not have any running sessions.
      <%= if true do %>
        <br />
        Looking for unsaved notebooks? <.link
          class="font-semibold"
          navigate={~p"/open/storage?autosave=true"}
          phx-no-format
        >Browse them here</.link>.
      <% end %>
    </.no_entries>
    """
  end

  defp session_list(assigns) do
    ~H"""
    <div class="flex flex-col" role="group" aria-label="running sessions list">
      <ul class="list bg-base-100">
        <li
          :for={project <- @projects}
          class="list-row"
          data-test-session-id={project.id}
        >
          <div>
            <img
              class="size-10 rounded-box"
              src="https://img.daisyui.com/images/profile/demo/1@94.webp"
            />
          </div>
          <div>
            <div>{project.name}</div>
            <div class="text-xs uppercase font-semibold opacity-60">Remaining Reason</div>
          </div>
          <button class="btn btn-square btn-ghost">
            <svg class="size-[1.2em]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <g
                stroke-linejoin="round"
                stroke-linecap="round"
                stroke-width="2"
                fill="none"
                stroke="currentColor"
              >
                <path d="M6 3L20 12 6 21 6 3z"></path>
              </g>
            </svg>
          </button>
          <button class="btn btn-square btn-ghost">
            <svg class="size-[1.2em]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <g
                stroke-linejoin="round"
                stroke-linecap="round"
                stroke-width="2"
                fill="none"
                stroke="currentColor"
              >
                <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z">
                </path>
              </g>
            </svg>
          </button>
        </li>
      </ul>
    </div>
    """
  end
end
