defmodule RairaWeb.ProjectLive.Form do
  use RairaWeb, :live_view
  alias RairaWeb.LayoutComponents

  alias Raira.Projects
  alias Raira.Projects.Project

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.drawer_layout current_page={~p"/"} current_user={@current_scope.user}>
      <div class="relative w-full max-w-screen-lg px-4 sm:pl-8 sm:pr-16 md:pl-16 pt-4 sm:py-5 mx-auto">
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="Project" />
        </div>

          <.form for={@form} id="project-form" phx-change="validate" phx-submit="save">
            <.input field={@form[:name]} type="text" label="Name" />
            <.input field={@form[:description]} type="textarea" label="Description" />
            <.input
              field={@form[:status]}
              type="select"
              label="Status"
              options={status_options()}
              prompt="Choose a status"
            />
            <footer>
              <.button phx-disable-with="Saving..." variant="primary">Save Project</.button>
              <.button navigate={return_path(@current_scope, @return_to, @project)}>Cancel</.button>
            </footer>
          </.form>
      </div>
    </LayoutComponents.drawer_layout>

    <!--
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage project records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="project-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={status_options()}
          prompt="Choose a status"
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Project</.button>
          <.button navigate={return_path(@current_scope, @return_to, @project)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    -->
    """
  end

  defp status_options do
    [
      {"Active", :active},
      {"Archived", :archived},
      {"Completed", :completed}
    ]
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    project = Projects.get_project!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, project)
    |> assign(:form, to_form(Projects.change_project(socket.assigns.current_scope, project)))
  end

  defp apply_action(socket, :new, _params) do
    project = %Project{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, project)
    |> assign(:form, to_form(Projects.change_project(socket.assigns.current_scope, project)))
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      Projects.change_project(
        socket.assigns.current_scope,
        socket.assigns.project,
        project_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.live_action, project_params)
  end

  defp save_project(socket, :edit, project_params) do
    case Projects.update_project(
           socket.assigns.current_scope,
           socket.assigns.project,
           project_params
         ) do
      {:ok, project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, project)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_project(socket, :new, project_params) do
    case Projects.create_project(socket.assigns.current_scope, project_params) do
      {:ok, project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, project)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _project), do: ~p"/projects"
  defp return_path(_scope, "show", project), do: ~p"/projects/#{project}"
end
