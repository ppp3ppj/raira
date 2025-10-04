defmodule RairaWeb.UserComponent do
  alias Raira.EctoTypes.HexColor
  use RairaWeb, :live_component
  import RairaWeb.UserComponents

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)
    user = socket.assigns.user |> IO.inspect(label: "PPPPP :")
    # changeset = Users.change_user(user)
    changeset = Raira.Accounts.change_user(user)

    {:ok, assign(socket, changeset: changeset, user: user)}
    # {:ok, assign(socket, user: user)}
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
      <.form
        :let={f}
        for={@changeset}
        phx-submit={@on_save |> JS.push("save")}
        phx-change="validate"
        phx-target={@myself}
        id="user_form"
        phx-hook="UserForm"
      >
        <!--
        <div class="flex flex-col space-y-5">
          <.text_field
            field={f[:name]}
            label="Display name"
            spellcheck="false"
            disabled={Livebook.Config.identity_provider_read_only?()}
          />
        -->

        <div class="flex flex-col space-y-5">
          <.text_field
            field={f[:name]}
            label="Display name"
            spellcheck="false"
          />
          <%= if @user.email do %>
            <.text_field field={f[:email]} label="email" spellcheck="false" disabled="true" />
          <% end %>

          <.hex_color_field
            field={f[:hex_color]}
            label="Cursor color"
            randomize={JS.push("randomize_color", target: @myself)}
          />

          <.button type="submit" disabled={not @changeset.valid?}>
            <.icon name="hero-archive-box-arrow-down" />
            <!--
            <.remix_icon icon="save-line" />
            -->
            <span>Save</span>
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("randomize_color", %{}, socket) do
    hex_color = HexColor.random(expect: [socket.assigns.user.hex_color])

    handle_event("validate", %{"user" => %{"hex_color" => hex_color}}, socket)
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      socket.assigns.user
      |> Raira.Accounts.change_user(params)
      |> Map.put(:action, :validate)

    user =
      if changeset.valid? do
        Ecto.Changeset.apply_action!(changeset, :update)
      else
        socket.assigns.user
      end

    {:noreply, assign(socket, changeset: changeset, user: user)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Raira.Accounts.update_user(socket.assigns.user, params) do
      {:ok, user} ->
        {:noreply, assign(socket, changeset: Raira.Accounts.change_user(user), user: user)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
