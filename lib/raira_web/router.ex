defmodule RairaWeb.Router do
  use RairaWeb, :router

  import RairaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RairaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RairaWeb do
    pipe_through :browser

    # get "/", PageController, :home
    # live "/", LandingLive.Welcome
    get "/landing", LandingPage.LandingPageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", RairaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:raira, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RairaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RairaWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{RairaWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email

      live "/", HomeLive, :page
      live "/settings", SettingsLive, :page
      live "/project", ProjectTestLive, :page


      live "/users", UserLive.Index, :index
      # FIXME If enable this /users/:id it error loop
      # This page isn't working
      # It got only /users/:id
      # must handel it uuid with uuid helper

      #live "/users/new", UserLive.Form, :new
      #live "/users/:id", UserLive.Show, :show
      #live "/users/:id/edit", UserLive.Form, :edit
      live "/projects", ProjectLive.Index, :index
      live "/projects/new", ProjectLive.Form, :new
      live "/projects/:id", ProjectLive.Show, :show
      live "/projects/:id/edit", ProjectLive.Form, :edit

      # FIXME: REMOVE IT
      live "/suites", SuiteLive.Index, :index
      live "/suites/new", SuiteLive.Form, :new
      live "/suites/:id", SuiteLive.Show, :show
      live "/suites/:id/edit", SuiteLive.Form, :edit
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", RairaWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{RairaWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new

      #live "/users", UserLive.Index, :index
      #live "/users/new", UserLive.Form, :new
      #live "/users/:id", UserLive.Show, :show
      #live "/users/:id/edit", UserLive.Form, :edit
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
