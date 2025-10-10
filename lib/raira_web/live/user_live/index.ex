defmodule RairaWeb.UserLive.Index do
  use RairaWeb, :live_view
  alias RairaWeb.LayoutComponents

  import RairaWeb.UserComponents

  alias Raira.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <LayoutComponents.layout current_page={~p"/users"} current_user={@current_scope.user} flash={@flash}>
      <div class="p-4 md:px-12 md:py-6 max-w-screen-lg mx-auto">
        <div class="flex flex-row space-y-0 items-center pb-4 justify-between">
          <LayoutComponents.title text="User management" />
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
          <:col :let={{_id, user}} label="Name">{user.first_name} {user.last_name}</:col>
          <:col :let={{_id, user}} label="Username">{user.username}</:col>
          <:col :let={{_id, user}} label="Email">{user.email}</:col>
          <:col :let={{_id, user}} label="Status">
            <.user_status_badge status={user.status} size={:sm} />
          </:col>
          <:action :let={{_id, user}}>
            <button class="btn btn-square" phx-click="approve_user" phx-value-id={user.id}>
              <svg
                class="w-6 h-6 text-gray-800 dark:text-white"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M5 11.917 9.724 16.5 19 7.5"
                />
              </svg>
            </button>

            <button class="btn btn-square" phx-click="reject_user" phx-value-id={user.id}>
              <svg
                class="w-6 h-6 text-gray-800 dark:text-white"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18 17.94 6M18 18 6.06 6"
                />
              </svg>
            </button>

            <button class="btn btn-square">
              <svg
                class="w-6 h-6 text-gray-800 dark:text-white"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-width="2"
                  d="m6 6 12 12m3-6a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                />
              </svg>
            </button>

            <button class="btn btn-square">
              <svg
                class="w-6 h-6 text-gray-800 dark:text-white"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M18.122 17.645a7.185 7.185 0 0 1-2.656 2.495 7.06 7.06 0 0 1-3.52.853 6.617 6.617 0 0 1-3.306-.718 6.73 6.73 0 0 1-2.54-2.266c-2.672-4.57.287-8.846.887-9.668A4.448 4.448 0 0 0 8.07 6.31 4.49 4.49 0 0 0 7.997 4c1.284.965 6.43 3.258 5.525 10.631 1.496-1.136 2.7-3.046 2.846-6.216 1.43 1.061 3.985 5.462 1.754 9.23Z"
                />
              </svg>
            </button>

    <!--
            <div class="sr-only">
              <.link navigate={~p"/users/#{user}"}>Show</.link>
            </div>
            <.link navigate={~p"/users/#{user}/edit"}>Edit</.link>
            <button phx-click="approve_user" phx-value-id={user.id}>
              Approve
            </button>

            <button phx-click="reject_user" phx-value-id={user.id}>
              Reject
            </button>

            <button phx-click="reopen_user" phx-value-id={user.id}>
              Reopen
            </button>
            -->
          </:action>
          <!--
          <:action :let={{id, user}}>
            <.link
              phx-click={JS.push("delete", value: %{id: user.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </:action>
          -->
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

  def handle_event("reopen_user", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    case Accounts.Approvals.reopen(user) do
      {:ok, updated} ->
        IO.inspect(updated, label: "✅ APPROVED")

        {:noreply,
         socket
         |> put_flash(
           :info,
           "Registered successfully"
         )
         |> stream_insert(:users, updated)}

      {:error, :cooldown} ->
        {:noreply, put_flash(socket, :error, "User still in cooldown period.")}

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
