defmodule RairaWeb.UserComponent do
  use RairaWeb, :live_component
  import RairaWeb.UserComponents

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)
    user = socket.assigns.user
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
          <!--
          <.hex_color_field
            field={f[:hex_color]}
            label="Cursor color"
            randomize={JS.push("randomize_color", target: @myself)}
          />
          -->
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
end
