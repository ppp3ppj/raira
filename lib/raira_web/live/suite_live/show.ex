defmodule RairaWeb.SuiteLive.Show do
  use RairaWeb, :live_view

  alias Raira.Testing

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Suite {@suite.id}
        <:subtitle>This is a suite record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/suites"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/suites/#{@suite}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit suite
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@suite.name}</:item>
        <:item title="Description">{@suite.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Testing.subscribe_suites(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Suite")
     |> assign(:suite, Testing.get_suite!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Raira.Testing.Suite{id: id} = suite},
        %{assigns: %{suite: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :suite, suite)}
  end

  def handle_info(
        {:deleted, %Raira.Testing.Suite{id: id}},
        %{assigns: %{suite: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current suite was deleted.")
     |> push_navigate(to: ~p"/suites")}
  end

  def handle_info({type, %Raira.Testing.Suite{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
