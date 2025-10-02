defmodule RairaWeb.UserComponent do
  use RairaWeb, :live_component
  import RairaWeb.UserComponents

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)
    user = socket.assigns.user
    # changeset = Users.change_user(user)

    # {:ok, assign(socket, changeset: changeset, user: user)}
    {:ok, assign(socket, user: user)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col space-y-5">
      <h3 class="text-2xl font-semibold text-gray-800">
        User profile
      </h3>
      <div class="flex justify-center">
        <.user_avatar user={@user} class="h-20 w-20" text_class="text-3xl" />
      </div>

    </div>
    """
  end
end
