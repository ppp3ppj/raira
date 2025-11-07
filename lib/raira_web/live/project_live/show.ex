defmodule RairaWeb.ProjectLive.Show do
  use RairaWeb, :live_view

  alias RairaWeb.LayoutComponents
  alias Raira.Projects

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.drawer_layout current_page={~p"/"} current_user={@current_scope.user}>
      <div class="relative w-full max-w-screen-lg px-4 sm:pl-8 sm:pr-16 md:pl-16 pt-4 sm:py-5 mx-auto">
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="Project" />
        </div>
        <.header>
          Project {@project.id}
          <:subtitle>This is a project record from your database.</:subtitle>
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
      </div>
    </LayoutComponents.drawer_layout>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Projects.subscribe_projects(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Project")
     |> assign(:project, Projects.get_project!(socket.assigns.current_scope, id))}
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
