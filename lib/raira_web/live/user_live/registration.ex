defmodule RairaWeb.UserLive.Registration do
  use RairaWeb, :live_view

  alias Raira.Accounts
  alias Raira.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm">
        <div class="text-center">
          <.header>
            Register for an account
            <:subtitle>
              Already registered?
              <.link navigate={~p"/users/log-in"} class="font-semibold text-brand hover:underline">
                Log in
              </.link>
              to your account now.
            </:subtitle>
          </.header>
        </div>

        <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
          <div class="card w-full max-w-md bg-base-100 shadow-sm">
            <div class="card-body">
              <div class="grid  sm:grid-cols-1 md:grid-cols-2 gap-3">
                <.input
                  field={@form[:first_name]}
                  type="text"
                  label="First name"
                  required
                  phx-mounted={JS.focus()}
                />
                <.input
                  field={@form[:last_name]}
                  type="text"
                  label="Last name"
                  required
                />
              </div>

              <.input
                field={@form[:username]}
                type="text"
                label="Username"
                required
              />

              <.input
                field={@form[:email]}
                type="email"
                label="Email"
                autocomplete="username"
                required
              />

              <.input
                field={@form[:password]}
                type="password"
                label="Password"
                required
              />

    <!--
              <.input
                field={@form[:email]}
                type="password"
                label="Confirm Password"
                required
              />

    -->
              <.button phx-disable-with="Creating account..." class="btn btn-primary w-full">
                Create an account
              </.button>

              <!--
              <div class="divider">or</div>
              -->
            </div>
          </div>

        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: RairaWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # {:ok, _} =
        #  Accounts.deliver_login_instructions(
        #    user,
        #    &url(~p"/users/log-in/#{&1}")
        #  )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "Registered successfully"
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
