defmodule RairaWeb.LayoutComponents do
  use RairaWeb, :html

  import RairaWeb.UserComponents

  @doc """
  The layout used in the non-sessios pages.
  """

  attr :current_page, :string, required: true
  attr :current_user, Raira.Accounts.User, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <div class="flex grow h-full">
      <div class="absolute md:static h-full z-[600]">
        <.sidebar current_page={@current_page} current_user={@current_user} />
      </div>

      <div class="grow overflow-y-auto">
        <div class="md:hidden sticky flex items-center justify-between h-14 px-4 top-0 left-0 z-[500] bg-white border-b border-gray-200">
          <div class="pt-1 text-xl text-gray-400 hover:text-gray-600 focus:text-gray-600">
            <button
              data-el-toggle-sidebar
              aria-label="show sidebar"
              phx-click={
                JS.remove_class("hidden", to: "[data-el-sidebar]")
                |> JS.toggle(to: "[data-el-toggle-sidebar]")
              }
            >
            </button>
          </div>
        </div>

        {render_slot(@inner_block)}
      </div>
    </div>

    <.current_user_modal current_user={@current_user} />
    <p>Current page: {@current_page}</p>
    <p>Current username: {@current_user.username}</p>
    """
  end

  @doc """
  The layout used in the non-sessios pages.
  """
  attr :current_page, :string, required: true
  attr :current_user, Raira.Accounts.User, required: true
  slot :inner_block, required: true

  def drawer_layout(assigns) do
    ~H"""
    <div class="flex grow h-full" data-el-session phx-hook="Session" id="session-root">
      <.drawer_sidebar current_page={@current_page} current_user={@current_user} />
      <.drawer_side_panel />

      <div class="grow overflow-y-auto">
        <div class="md:hidden sticky flex items-center justify-between h-14 px-4 top-0 left-0 z-[500] bg-white border-b border-gray-200">
          <div class="pt-1 text-xl text-gray-400 hover:text-gray-600 focus:text-gray-600">
            <button
              data-el-toggle-sidebar
              aria-label="show sidebar"
              phx-click={
                JS.remove_class("hidden", to: "[data-el-sidebar]")
                |> JS.toggle(to: "[data-el-toggle-sidebar]")
              }
            >
            </button>
          </div>
        </div>

        {render_slot(@inner_block)}
      </div>
    </div>

    <.current_user_modal current_user={@current_user} />
    """
  end

  defp drawer_sidebar(assigns) do
    ~H"""
    <nav
      class="w-16 flex flex-col items-center px-3 py-1 space-y-2 sm:space-y-3 sm:py-5 bg-gray-900"
      aria-label="sidebar"
      data-el-sidebar
    >
      <span>
        <.link navigate={~p"/"} aria-label="go to homepage">
          <img src={~p"/images/logo.png"} height="40" width="40" alt="" />
        </.link>
      </span>

      <%!-- Local functionality --%>

      <.button_item
        icon="hero-home"
        label="Outline (so)"
        button_attrs={["data-el-outline-toggle": true]}
      />

      <.button_item
        icon="hero-home"
        label="Clients (so)"
        button_attrs={["data-el-clients-list-toggle": true]}
      />

      <.button_item
        icon="hero-user"
        label="Connected users (su)"
        button_attrs={["data-el-others-list-toggle": true]}
      />

      <.button_item
        icon="hero-chat-bubble-oval-left-ellipsis"
        label="Clients (so)"
        button_attrs={["data-el-messages-list-toggle": true]}
      />
      <!--

      <div class="relative">
        <.button_item
          icon="cpu-line"
          label="Runtime settings (sr)"
          button_attrs={["data-el-runtime-info-toggle": true]}
        />
        <div
          :if={@runtime_connected_nodes != []}
          data-el-runtime-indicator
          class={[
            "absolute w-[12px] h-[12px] border-gray-900 border-2 rounded-full right-1.5 top-1.5 pointer-events-none",
            "bg-blue-500"
          ]}
        />
      </div>
      -->

      <%!-- Hub functionality --%>

    <!--
      <.button_item
        icon="lock-password-line"
        label="Secrets (ss)"
        button_attrs={["data-el-secrets-list-toggle": true]}
      />

      <.button_item
        icon="folder-open-fill"
        label="Files (sf)"
        button_attrs={["data-el-files-list-toggle": true]}
      />

      <.button_item
        icon="rocket-line"
        label="App settings (sa)"
        button_attrs={["data-el-app-info-toggle": true]}
      />

      <div class="grow"></div>

      <.link_item
        icon="delete-bin-6-fill"
        label="Bin (sb)"
        path={~p"/sessions/#{@session.id}/bin"}
        active={@live_action == :bin}
        link_attrs={["data-btn-show-bin": true]}
      />

      <.link_item
        icon="keyboard-box-fill"
        label="Keyboard shortcuts (?)"
        path={~p"/sessions/#{@session.id}/shortcuts"}
        active={@live_action == :shortcuts}
        link_attrs={["data-btn-show-shortcuts": true]}
      />
      -->
      <div class="grow"></div>

      <.button_item
        icon="hero-camera"
        label="Outline (so)"
        button_attrs={["data-el-outline-toggle": true]}
      />
      <span class="tooltip right distant" data-tooltip="User profile">
        <button
          class="text-gray-400 rounded-xl h-8 w-8 flex items-center justify-center mt-2 group"
          aria_label="user profile"
          phx-click={show_current_user_modal()}
        >
          <.user_avatar
            user={@current_user}
            class="w-8 h-8 group-hover:ring-white group-hover:ring-2"
            text_class="text-xs"
          />
        </button>
      </span>
    </nav>
    """
  end

  defp drawer_side_panel(assigns) do
    ~H"""
    <div
      class="flex flex-col h-full w-full max-w-xs absolute z-30 top-0 left-[64px] overflow-y-auto shadow-xl md:static md:shadow-none bg-gray-50 border-r border-gray-100 px-6 pt-16 md:py-8"
      data-el-side-panel
    >
      <.clients_list />
      <.others_list />
      <.messages_list />
    </div>
    """
  end

  defp sidebar(assigns) do
    ~H"""
    <nav class="hidden md:flex w-[17rem] h-full py-2 md:py-5 bg-gray-900">
      <div class="flex flex-col justify-between h-full w-full">
        <div class="flex flex-col">
          <div class="space-y-3">
            <div class="flex items-center mb-5">
              <.link navigate={~p"/"} class="flex items-center ml-1 group" current={~p"/"}>
                <img
                  class="mx-2"
                  height="40"
                  width="40"
                  alt="logo livebook"
                />

                <span class="text-gray-300 text-2xl font-logo ml-[-1px] group-hover:text-white pt-1">
                  Raira
                </span>
              </.link>

              <span class="text-gray-300 text-xs font-normal font-sans mx-2.5 pt-3 cursor-default">
                v{Raira.Config.app_version()}
              </span>
            </div>

            <.sidebar_link title="Home" icon="hero-home" to={~p"/"} current={@current_page} />
            <.sidebar_link
              title="Settings"
              icon="hero-cog-8-tooth"
              to={~p"/settings"}
              current={@current_page}
            />
          </div>
          <.feature_section
            title="Admin"
            max_items={4}
            features={[
              %{id: 1, name: "Users", emoji: "👥"},
              %{id: 2, name: "Orders", emoji: "🧾"},
              %{id: 3, name: "Customers", emoji: "👥"},
              %{id: 4, name: "Reports", emoji: "📊"},
              %{id: 5, name: "Dashboard", emoji: "🏠"},
              %{id: 6, name: "Dashboard", emoji: "🏠"}
            ]}
            see_more_uri={~p"/features"}
            current={@current_page}
          />
        </div>

        <div class="flex flex-col">
          <button
            :if={false}
            class="h-7 flex items-center text-gray-400 hover:text-white border-l-4 border-transparent hover:border-white"
            aria-label="logout"
            phx-click="logout"
          >
            <span class="text-sm font-medium">
              Logout
            </span>
          </button>

          <button
            phx-click={show_current_user_modal()}
            class="mt-6 flex items-center group border-l-4 border-transparent"
            aria_label="user profile"
          >
            <div class="w-[56px] flex justify-center">
              <.user_avatar
                user={@current_user}
                class="w-8 h-8 group-hover:ring-white group-hover:ring-2"
                text_class="text-xs"
              />
            </div>
            <span class="text-sm text-gray-400 font-medium group-hover:text-white">
              {@current_user.username}
            </span>
          </button>
        </div>
      </div>
    </nav>
    """
  end

  defp sidebar_link(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={[
        "h-7 flex items-center hover:text-white border-l-4 hover:border-white",
        sidebar_link_text_color(@to, @current),
        sidebar_link_border_color(@to, @current)
      ]}
    >
      <span class="w-[56px] grid place-items-center">
        <.icon name={@icon} class="text-lg leading-none" />
      </span>
      <!--
      <.icon name={@icon} class="text-lg leading-6 w-[56px] flex justify-center" />
      <%= if is_binary(@icon) and String.starts_with?(@icon, "hero-") do %>
        <.icon name={@icon} class="text-lg leading-6 w-[56px] flex justify-center" />
      <% else %>
        <.icon name="hero-bug-ant" class="text-lg leading-6 w-[56px] flex justify-center" />
      <% end %>
      -->
      <!--
      <.remix_icon icon={@icon} class="text-lg leading-6 w-[56px] flex justify-center" />
      <.icon name="hero-bug-ant" class="text-lg leading-6 w-[56px] flex justify-center" />
      -->
      <span class="text-sm font-medium">
        {@title}
      </span>
    </.link>
    """
  end

  @doc """
  Renders page title.

  ## Examples

      <.title text="Learn" />

  """
  attr :text, :string, default: nil
  attr :back_navigate, :string, default: nil

  slot :inner_block

  def title(assigns) do
    if assigns.text == nil and assigns.inner_block == [] do
      raise ArgumentError, "should pass at least text attribute or an inner block"
    end

    ~H"""
    <div class="relative">
      <div
        :if={@back_navigate}
        class="hidden md:flex absolute top-0 bottom-0 left-0 transform -translate-x-full"
      >
        <.link navigate={@back_navigate}>
          <.icon name="hero-arrow-left-line" class="align-middle mr-2 text-2xl text-gray-800" />
        </.link>
      </div>
      <h1 class="text-2xl text-gray-800 font-medium">
        <%= if @inner_block != [] do %>
          {render_slot(@inner_block)}
        <% else %>
          {@text}
        <% end %>
      </h1>
    </div>
    """
  end

  defp sidebar_link_text_color(to, current) when to == current, do: "text-white"
  defp sidebar_link_text_color(_to, _current), do: "text-gray-400"

  defp sidebar_link_border_color(to, current) when to == current, do: "border-white"
  defp sidebar_link_border_color(_to, _current), do: "border-transparent"

  defp button_item(assigns) do
    ~H"""
    <span class="tooltip right distant" data-tooltip={@label}>
      <button
        class="text-2xl text-gray-400 hover:text-gray-50 focus:text-gray-50 rounded-xl h-10 w-10 flex items-center justify-center"
        aria-label={@label}
        {@button_attrs}
      >
        <.icon name={@icon} />
      </button>
    </span>
    """
  end

  defp clients_list(assigns) do
    ~H"""
    <div class="flex flex-col grow" data-el-clients-list>
      <div class="flex items-center justify-between space-x-4 -mt-1">
        <h3 class="uppercase text-sm font-semibold text-gray-500">
          Users
        </h3>
        <span class="flex items-center px-2 py-1 space-x-2 text-sm bg-gray-200 rounded-lg">
          <span class="inline-flex w-3 h-3 bg-green-600 rounded-full"></span>
          <!--
          <span>{length(@data_view.clients)} connected</span>
          -->

          <!-- Example: <span>3 connected</span> -->
        </span>
      </div>
      <div class="flex flex-col mt-5 space-y-4">
        <!-- client list items -->
      </div>
    </div>
    """
  end

  defp others_list(assigns) do
    ~H"""
    <div class="flex flex-col grow" data-el-others-list>
      <div class="flex items-center justify-between space-x-4 -mt-1">
        <h3 class="uppercase text-sm font-semibold text-gray-500">
          Others
        </h3>
        <span class="flex items-center px-2 py-1 space-x-2 text-sm bg-gray-200 rounded-lg">
          <span class="inline-flex w-3 h-3 bg-green-600 rounded-full"></span>
          <!--
          <span>{length(@data_view.clients)} connected</span>
          -->

          <!-- Example: <span>3 connected</span> -->
        </span>
      </div>
      <div class="flex flex-col mt-5 space-y-4">
        <!-- client list items -->
      </div>
    </div>
    """
  end

  defp messages_list(assigns) do
    ~H"""
    <div class="flex flex-col grow" data-el-messages-list>
      <div class="flex items-center justify-between space-x-4 -mt-1">
        <h3 class="uppercase text-sm font-semibold text-gray-500">
          Messages
        </h3>
        <span class="flex items-center px-2 py-1 space-x-2 text-sm bg-gray-200 rounded-lg">
          <span class="inline-flex w-3 h-3 bg-green-600 rounded-full"></span>
          <!--
          <span>{length(@data_view.clients)} connected</span>
          -->

          <!-- Example: <span>3 connected</span> -->
        </span>
      </div>
      <div class="flex flex-col mt-5 space-y-4">
        <!-- client list items -->
      </div>
    </div>
    """
  end

  @doc """
  Renders a **feature section** in the sidebar, showing a list of feature links
  with an optional “See more” link if the number of features exceeds `max_items`.

  ## Examples

  ```heex
  <.feature_section
  title="Hubs"
  current="/hub/analytics"
  features={[
    %{id: 1, name: "Analytics", emoji: "📊"},
    %{id: 2, name: "Reports", emoji: "📄"},
    %{id: 3, name: "Settings", emoji: "⚙️"}
  ]}
  />
  """
  attr :title, :string, default: nil
  attr :max_items, :integer, default: 5
  attr :current, :string, default: nil
  attr :features, :list, required: true
  attr :see_more_uri, :string, default: "/hub"

  defp feature_section(assigns) do
    ~H"""
    <div id="hubs" class="flex flex-col mt-12">
      <div class="space-y-3">
        <div class="grid grid-cols-1 md:grid-cols-2 relative leading-6 mb-2">
          <small class="ml-5 font-medium text-gray-300 cursor-default">{@title}</small>
        </div>

        <%= for feature <- Enum.take(@features, @max_items) do %>
          <.sidebar_feature_link
            feature={feature}
            to={~p"/#{feature.name |> String.downcase()}"}
            current={@current}
          />
        <% end %>

        <%= if length(@features) > @max_items do %>
          <.sidebar_link
            title="See more"
            icon="hero-rss"
            to={@see_more_uri}
            current={@current}
          />
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a single sidebar feature link.

  Each feature link displays an emoji and name, highlights the active feature based on `@current`,
  and navigates to the given `@to` path when clicked.

  ## Example

  ```heex
  <.sidebar_feature_link
    feature=%{id: 1, name: "Analytics", emoji: "📊"}
    to="/analytics"
    current="/analytics"
  />
  """

  defp sidebar_feature_link(assigns) do
    ~H"""
    <.link
      id={"hub-#{@feature.id}"}
      navigate={@to}
      class={[
        "h-7 flex items-center hover:text-white border-l-4 hover:border-white",
        sidebar_link_text_color(@to, @current),
        sidebar_link_border_color(@to, @current)
      ]}
    >
      <div class="text-lg leading-6 w-[56px] flex justify-center">
        <span class="relative">
          {@feature.emoji}
        </span>
      </div>
      <span class="text-sm font-medium">
        {@feature.name}
      </span>
    </.link>
    """
  end
end
