defmodule RairaWeb.ProjectLive.Show do
  use RairaWeb, :live_view

  alias RairaWeb.LayoutComponents
  alias Raira.Projects

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.drawer_layout current_page={~p"/"} current_user={@current_scope.user}>
      <div class="relative w-full max-w-screen-lg px-4 sm:pl-8 sm:pr-16 md:pl-16 pt-4 sm:py-5 mx-auto">
        <!--
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="Project" />
        </div>

        <.header>
          Project {@project.name}
          <:subtitle>{@project.description || "No description"}</:subtitle>
          <:actions>
            <.button navigate={~p"/projects"}>
              <.icon name="ri-arrow-go-back-line" class="h-4 w-4" />
            </.button>
            <.button variant="primary" navigate={~p"/projects/#{@project}/edit?return_to=show"}>
              <.icon name="ri-edit-line" class="h-4 w-4" /> Edit project
            </.button>
          </:actions>
        </.header>

        <.list>
          <:item title="Name">{@project.name}</:item>
          <:item title="Description">{@project.description}</:item>
          <:item title="Status">{@project.status}</:item>
        </.list>
        -->

        <div class="mb-6">
          <.button navigate={~p"/projects"} variant="ghost" class="mb-4">
            <.icon name="ri-arrow-go-back-line" class="h-4 w-4" /> Back to Projects
          </.button>

          <div class="flex items-start justify-between">
            <div class="min-w-0 flex-1">
              <h1 class="text-4xl font-bold text-gray-900">{@project.name}</h1>
              <div class="mt-3 flex items-center gap-3">
                <span class={[
                  "inline-flex items-center rounded-full px-3 py-1 text-xs font-medium",
                  @project.status == :active && "bg-green-100 text-green-800",
                  @project.status == :archived && "bg-gray-100 text-gray-800",
                  @project.status == :completed && "bg-blue-100 text-blue-800"
                ]}>
                  {@project.status}
                </span>
                <span class="text-xs text-gray-500">
                  Created {Calendar.strftime(@project.inserted_at, "%B %d, %Y")}
                </span>
              </div>
            </div>
            <div class="ml-4">
              <.button navigate={~p"/projects/#{@project}/edit?return_to=show"} variant="primary">
                <.icon name="ri-edit-line" class="h-4 w-4" /> Edit
              </.button>
            </div>
          </div>
        </div>


        <div class="mt-6 border-b border-gray-200">
          <nav class="flex space-x-4" aria-label="Tabs">
            <.tab_link
              navigate={~p"/projects/#{@project}"}
              active={@live_action == :overview}
            >
              <.icon name="ri-dashboard-line" class="h-5 w-5" /> Overview
            </.tab_link>

            <.tab_link
              navigate={~p"/projects/#{@project}/suites"}
              active={@live_action in [:suites, :new_suite, :edit_suite]}
            >
              <.icon name="ri-folder-3-line" class="h-5 w-5" />
              Test Suites
              <!--
              <span
                :if={@suite_count > 0}
                class="ml-2 rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-600"
              >
                {@suite_count}

              </span>
              -->
            </.tab_link>

            <.tab_link
              navigate={~p"/projects/#{@project}/runs"}
              active={@live_action == :runs}
            >
              <.icon name="ri-play-circle-line" class="h-5 w-5" /> Test Runs
            </.tab_link>

            <.tab_link
              navigate={~p"/projects/#{@project}/stats"}
              active={@live_action == :stats}
            >
              <.icon name="ri-bar-chart-line" class="h-5 w-5" /> Statistics
            </.tab_link>

            <.tab_link
              navigate={~p"/projects/#{@project}/settings"}
              active={@live_action == :settings}
            >
              <.icon name="ri-settings-3-line" class="h-5 w-5" /> Settings
            </.tab_link>
          </nav>
        </div>
        <div class="mt-6">
          <div :if={@live_action == :stats}>
            <.mock_tab
              icon="ri-bar-chart-line"
              title="Statistics"
              description="Coming soon - View test execution statistics and trends"
            />
          </div>

          <div :if={@live_action == :settings}>
            <.mock_tab
              icon="ri-settings-3-line"
              title="Settings"
              description="Coming soon - Configure project settings"
            />
          </div>
        </div>
      </div>
    </LayoutComponents.drawer_layout>
    """
  end

  defp tab_link(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      class={[
        "flex items-center gap-x-2 rounded-md px-3 py-2 text-sm font-medium",
        (@active && "bg-gray-100 text-gray-900") ||
          "text-gray-500 hover:text-gray-700 hover:bg-gray-50"
      ]}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  defp mock_tab(assigns) do
    ~H"""
    <div class="text-center py-12 bg-gray-50 rounded-lg">
      <.icon name={@icon} class="mx-auto h-12 w-12 text-gray-400" />
      <h3 class="mt-2 text-sm font-semibold text-gray-900">{@title}</h3>
      <p class="mt-1 text-sm text-gray-500">{@description}</p>
    </div>
    """
  end

  # === LIFECYCLE ===

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Projects.subscribe_projects(socket.assigns.current_scope)
    end

    project = Projects.get_project!(socket.assigns.current_scope, id)

    {:ok,
     socket
     |> assign(:page_title, "Show Project")
     |> assign(:project, project)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Show - #{socket.assigns.project.name}")
  end

  defp apply_action(socket, :stats, _params) do
    socket
    |> assign(:page_title, "Statistics - #{socket.assigns.project.name}")
  end

  defp apply_action(socket, :settings, _params) do
    socket
    |> assign(:page_title, "Settings - #{socket.assigns.project.name}")
  end

  defp apply_action(socket, :suites, _params) do
    suites = Testing.list_suites_by_project(socket.assigns.project.id)

    socket
    |> assign(:page_title, "Test Suites - #{socket.assigns.project.name}")
    |> assign(:suites, suites)
    |> assign(:suite_count, length(suites))
    |> assign(:suite, nil)
  end

  @impl true
  def handle_info(
        {:updated, %Raira.Projects.Project{id: id} = project},
        %{assigns: %{project: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :project, project)}
  end

  def handle_info(
        {:deleted, %Raira.Projects.Project{id: id}},
        %{assigns: %{project: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current project was deleted.")
     |> push_navigate(to: ~p"/projects")}
  end

  def handle_info({type, %Raira.Projects.Project{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
