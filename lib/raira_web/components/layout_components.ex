defmodule RairaWeb.LayoutComponents do
  use RairaWeb, :html

  @doc """
  The layout used in the non-sessios pages.
  """

  attr :current_page, :string, required: true
  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
  slot :inner_block, required: true
  def layout(assigns) do
    ~H"""
    <div class="flex grow h-full">
      <div class="absolute md:static h-full z-[600]">
        <.sidebar />
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

    <!-- fix it to modal -->

    <!--
    <.current_user_modal current_user={@current_user} />
    -->
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
                v{"0.0.0-dev"}
              </span>
            </div>

            <!--
            <.sidebar_link title="Home" icon="home-6-line" to={~p"/"} current={@current_page} />
            -->
          </div>
        </div>

        <div class="flex flex-col">
          <button
            class="h-7 flex items-center text-gray-400 hover:text-white border-l-4 border-transparent hover:border-white"
            aria-label="logout"
            phx-click="logout"
          >
            <span class="text-sm font-medium">
              Logout
            </span>
          </button>

          <button
            class="mt-6 flex items-center group border-l-4 border-transparent"
            aria_label="user profile"
          >
            <span class="text-sm text-gray-400 font-medium group-hover:text-white">
              Current
            </span>
          </button>
        </div>
      </div>
    </nav>
    """
  end
end
