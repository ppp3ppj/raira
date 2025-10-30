defmodule RairaWeb.HomeLive do
  alias Raira.Projects
  alias RairaWeb.LayoutComponents
  use RairaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns |> IO.inspect(label: "TEST")

    projects = [
      %{id: "TEST1", name: "SandClock", description: "Time tracking app", status: :active},
      %{id: "TEST2", name: "TrackMDay", description: "Track your day with simplicity", status: :active},
      %{id: "TEST3", name: "POSify", description: "POS system for cafes", status: :archived},
      %{id: "TEST4", name: "GoothStack", description: "Go + Elixir + Haskell experiment", status: :pending},
      %{id: "TEST5", name: "KitchenView", description: "Monitor kitchen orders", status: :active}
    ]

    projects_empty = []

    {:ok, assign(socket, self_path: ~p"/", page_title: "Home", projects: projects)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.layout current_page={~p"/"} current_user={@current_scope.user} flash={@flash}>
      <div class="p-4 md:px-12 md:py-6 max-w-screen-lg mx-auto">
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="Home" />
          <div class="hidden md:flex space-x-2" role="navigation" aria-label="new notebook">
            <.button color="gray" outlined navigate={~p"/open/storage"}>
              Open
            </.button>
            <.button color="blue" patch={~p"/projects/new"}>
              <.icon name="ri-add-line" />
              <span>New notebook</span>
            </.button>
          </div>
        </div>

        <div id="starred-notebooks" role="region" aria-label="starred notebooks">
          <div class="my-4 flex items-center md:items-end justify-between">
            <h2 class="uppercase font-semibold text-gray-500 text-sm md:text-base">
              Starred notebooks
            </h2>
            <button
              class="flex items-center text-blue-600"
              phx-click="toggle_starred_expanded"
            >
              <span class="font-semibold">Show more</span>
            </button>
          </div>
          <%= if @projects == [] do %>
            Empty
          <% else %>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5" role="group">
            <%= for {item, idx} <- Enum.with_index(@projects) do %>
                   <div
                  class="flex flex-col p-4 border bg-gray-50 border-gray-300 rounded-lg"
              >
                <div class="flex items-center justify-between">
                  <span class="tooltip top" >
                    <span class="text-gray-800 font-medium">
                      {item.name}
                    </span>
                  </span>
              <!--
                  {@card_icon && render_slot(@card_icon, {info, idx})}
              -->
                </div>
                <div class="mt-1 flex-grow text-gray-600 text-sm">
              <!--
                  {@added_at_label}

                  {LivebookWeb.HTMLHelpers.format_datetime_relatively(info.added_at)} ago
              -->
                </div>
                <div class="mt-2 flex space-x-6">
                  <button
                    class="text-blue-600 font-medium"
                    phx-click={JS.push("fork", value: %{idx: idx})}
                  >
                    Fork
                  </button>
                </div>
              </div>
              <% end %>

            </div>
          <% end %>
        </div>

        <div id="running-sessions" class="py-20 mb-32" role="region" aria-label="running sessions">
          <.live_component
            module={RairaWeb.HomeLive.ProjectListComponent}
            id="projects-list"
            projects={@projects}
          />
        </div>
      </div>
    </LayoutComponents.layout>
    """
  end
end
