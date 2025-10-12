defmodule RairaWeb.UserComponents do
  use RairaWeb, :html

  @doc """
  Renders user avatar.

  ## Examples

      <.user_avatar user={@user} class="h-20 w-20" text_class="text-3xl" />

  """
  attr :user, Raira.Accounts.User, required: true
  attr :class, :string, default: "w-full h-full"
  attr :text_class, :string, default: nil

  def user_avatar(assigns) do
    ~H"""
    <.avatar_text class={@class} user={@user} text_class={@text_class} />
    """
  end

  defp avatar_text(assigns) do
    ~H"""
    <!--
    <div
      class={["rounded-full flex items-center justify-center", @class]}
      style={"background-color: #{@user.hex_color}"}
      aria-hidden="true"
    >
    -->

    <div
      class={["rounded-full flex items-center justify-center", @class]}
      aria-hidden="true"
    >
      <div class={["text-gray-100 font-semibold", @text_class]}>
        {initials(@user.username)}
      </div>
    </div>
    """
  end

  defp initials(nil), do: "?"

  defp initials(name) do
    name
    |> String.split()
    |> Enum.map(&String.at(&1, 0))
    |> Enum.map(&String.upcase/1)
    |> case do
      [initial] -> initial
      initials -> List.first(initials) <> List.last(initials)
    end
  end

  @doc """
  Renders the current user edit form in a modal.

  ## Examples

      <.current_user_modal current_user={@current_user} />

  """
  attr :current_user, Raira.Accounts.User, required: true

  def current_user_modal(assigns) do
    ~H"""
    <.modal id="user-modal" width="small">
      <.live_component
        module={RairaWeb.UserComponent}
        id="user"
        user={@current_user}
        on_save={hide_current_user_modal()}
      />
    </.modal>
    """
  end

  def show_current_user_modal(js \\ %JS{}), do: show_modal(js, "user-modal")
  def hide_current_user_modal(js \\ %JS{}), do: hide_modal(js, "user-modal")


  @doc "Badge for user status: :confirmed | :pending | :rejected | :banned (optional)"
  attr :status, :atom, required: true, values: [:confirmed, :pending, :rejected, :banned]
  attr :size,   :atom, default: :md, values: [:sm, :md, :lg]
  attr :class,  :string, default: nil
  def user_status_badge(assigns) do
    ~H"""
    <div class={["badge", size_class(@size), color_class(@status), @class]}>
      {label_text(@status)}
    </div>
    """
  end

  defp color_class(:confirmed), do: "badge-success"
  defp color_class(:pending), do: "badge-warning"
  defp color_class(:rejected), do: "badge-error"
  defp color_class(:banned), do: "badge-neutral"
  defp color_class(_), do: "badge-info"

  defp label_text(:confirmed), do: "Confirmed"
  defp label_text(:pending), do: "Pending"
  defp label_text(:rejected), do: "Rejected"
  defp label_text(:banned), do: "Banned"
  defp label_text(_), do: "Info"

  defp size_class(:sm), do: "badge-sm"
  defp size_class(:lg), do: "badge-lg"
  defp size_class(_), do: ""
end
