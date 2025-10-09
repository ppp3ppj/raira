defmodule RairaWeb.UserLive.Index do
  use RairaWeb, :live_view
  alias RairaWeb.LayoutComponents

  alias Raira.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.layout current_page={~p"/users"} current_user={@current_scope.user}>
      <div class="p-4 md:px-12 md:py-6 max-w-screen-lg mx-auto">
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="Home" />
          <div class="hidden md:flex space-x-2" role="navigation" aria-label="new notebook">
            <.button color="blue" patch={~p"/users/new"}>
              <.icon name="hero-plus" />
              <span>New User</span>
            </.button>
          </div>
        </div>
        <.table
          id="users"
          rows={@streams.users}
          row_click={fn {_id, user} -> JS.navigate(~p"/users/#{user}") end}
        >
          <:col :let={{_id, user}} label="First name">{user.first_name}</:col>
          <:col :let={{_id, user}} label="Last name">{user.last_name}</:col>
          <:col :let={{_id, user}} label="Username">{user.username}</:col>
          <:col :let={{_id, user}} label="Email">{user.email}</:col>
          <:col :let={{_id, user}} label="Status">{user.status}</:col>
          <:action :let={{_id, user}}>
            <div class="sr-only">
              <.link navigate={~p"/users/#{user}"}>Show</.link>
            </div>
            <.link navigate={~p"/users/#{user}/edit"}>Edit</.link>
            <!--
            <button phx-click={JS.push("approve_user", value: %{id: user.id})}>Approve</button>
            -->
            <button phx-click="approve_user" phx-value-id={user.id}>
              Approve
            </button>

            <button phx-click="reject_user" phx-value-id={user.id}>
              Reject
            </button>
          </:action>
          <:action :let={{id, user}}>
            <.link
              phx-click={JS.push("delete", value: %{id: user.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </:action>
        </.table>
      </div>
    </LayoutComponents.layout>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket) do
    #  Accounts.subscribe_users(socket.assigns.current_scope)
    # end

    {:ok,
     socket
     |> assign(:page_title, "Listing Users")
     |> stream(:users, list_users(socket.assigns.current_scope))}
  end

  def handle_event("reject_user", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    # user = %{user | reject_reason: "TEST"}

    case Accounts.Approvals.reject(user, "TEST") do
      {:ok, updated} ->
        IO.inspect(updated, label: "✅ APPROVED")

        {:noreply,
         socket
         |> put_flash(
           :info,
           "Registered successfully"
         )
         |> stream_insert(:users, updated)}

      {:error, :banned} ->
        {:noreply, put_flash(socket, :error, "User is banned.")}

      {:error, :invalid_state} ->
        {:noreply, put_flash(socket, :error, "Only pending users can be approved.")}

      {:error, %Ecto.Changeset{}} ->
        {:noreply, put_flash(socket, :error, "Could not approve. Try reload.")}
    end
  end

  def handle_event("approve_user", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    case Accounts.Approvals.approve(user) do
      {:ok, updated} ->
        IO.inspect(updated, label: "✅ APPROVED")

        {:noreply,
         socket
         |> put_flash(
           :info,
           "Registered successfully"
         )
         |> stream_insert(:users, updated)}

      {:error, :banned} ->
        {:noreply, put_flash(socket, :error, "User is banned.")}

      {:error, :invalid_state} ->
        {:noreply, put_flash(socket, :error, "Only pending users can be approved.")}

      {:error, %Ecto.Changeset{}} ->
        {:noreply, put_flash(socket, :error, "Could not approve. Try reload.")}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(socket.assigns.current_scope, id)
    {:ok, _} = Accounts.delete_user(socket.assigns.current_scope, user)

    {:noreply, stream_delete(socket, :users, user)}
  end

  @impl true
  def handle_info({type, %Raira.Accounts.User{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :users, list_users(socket.assigns.current_scope), reset: true)}
  end

  defp list_users(current_scope) do
    Accounts.list_users(current_scope)
  end
end
