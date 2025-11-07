defmodule RairaWeb.SuiteLive.Form do
  use RairaWeb, :live_view

  alias Raira.Testing
  alias Raira.Testing.Suite

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage suite records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="suite-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Suite</.button>
          <.button navigate={return_path(@current_scope, @return_to, @suite)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
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
    suite = Testing.get_suite!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Suite")
    |> assign(:suite, suite)
    |> assign(:form, to_form(Testing.change_suite(socket.assigns.current_scope, suite)))
  end

  defp apply_action(socket, :new, _params) do
    suite = %Suite{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Suite")
    |> assign(:suite, suite)
    |> assign(:form, to_form(Testing.change_suite(socket.assigns.current_scope, suite)))
  end

  @impl true
  def handle_event("validate", %{"suite" => suite_params}, socket) do
    changeset = Testing.change_suite(socket.assigns.current_scope, socket.assigns.suite, suite_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"suite" => suite_params}, socket) do
    save_suite(socket, socket.assigns.live_action, suite_params)
  end

  defp save_suite(socket, :edit, suite_params) do
    case Testing.update_suite(socket.assigns.current_scope, socket.assigns.suite, suite_params) do
      {:ok, suite} ->
        {:noreply,
         socket
         |> put_flash(:info, "Suite updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, suite)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_suite(socket, :new, suite_params) do
    case Testing.create_suite(socket.assigns.current_scope, suite_params) do
      {:ok, suite} ->
        {:noreply,
         socket
         |> put_flash(:info, "Suite created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, suite)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _suite), do: ~p"/suites"
  defp return_path(_scope, "show", suite), do: ~p"/suites/#{suite}"
end
