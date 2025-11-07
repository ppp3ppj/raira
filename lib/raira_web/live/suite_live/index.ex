defmodule RairaWeb.SuiteLive.Index do
  use RairaWeb, :live_view

  alias Raira.Testing

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Suites
        <:actions>
          <.button variant="primary" navigate={~p"/suites/new"}>
            <.icon name="ri-plus" /> New Suite
          </.button>
        </:actions>
      </.header>

      <.table
        id="suites"
        rows={@streams.suites}
        row_click={fn {_id, suite} -> JS.navigate(~p"/suites/#{suite}") end}
      >
        <:col :let={{_id, suite}} label="Name">{suite.name}</:col>
        <:col :let={{_id, suite}} label="Description">{suite.description}</:col>
        <:action :let={{_id, suite}}>
          <div class="sr-only">
            <.link navigate={~p"/suites/#{suite}"}>Show</.link>
          </div>
          <.link navigate={~p"/suites/#{suite}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, suite}}>
          <.link
            phx-click={JS.push("delete", value: %{id: suite.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Testing.subscribe_suites(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Suites")
     |> stream(:suites, list_suites(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    suite = Testing.get_suite!(socket.assigns.current_scope, id)
    {:ok, _} = Testing.delete_suite(socket.assigns.current_scope, suite)

    {:noreply, stream_delete(socket, :suites, suite)}
  end

  @impl true
  def handle_info({type, %Raira.Testing.Suite{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :suites, list_suites(socket.assigns.current_scope), reset: true)}
  end

  defp list_suites(current_scope) do
    Testing.list_suites(current_scope)
  end
end
