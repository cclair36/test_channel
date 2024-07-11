defmodule TestChannelWeb.Router do
  use TestChannelWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TestChannelWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestChannelWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/index", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TestChannelWeb do
  #   pipe_through :api
  # end
defp put_user_token(conn, _) do
  if current_user = conn.assigns[:current_user] do
    token = Phoenix.Token.sign(conn, "user socket", current_user.id)
    assign(conn, :user_token, token)
  else
    conn
  end
end
  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:test_channel, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TestChannelWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
