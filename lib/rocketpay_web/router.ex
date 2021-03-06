defmodule RocketpayWeb.Router do
  use RocketpayWeb, :router

  # import Plug.BasicAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    # plug :basic_auth, Application.compile_env(:rocketpay, :basic_auth)
    plug RocketpayWeb.Auth.Pipeline
  end

  scope "/api", RocketpayWeb do
    pipe_through :api

    get "/welcome/:filename", WelcomeController, :index

    post "/users", UsersController, :create

    post "/auth/login", AuthController, :login
  end

  scope "/api", RocketpayWeb do
    pipe_through [:api, :auth]

    get "/auth/me", AuthController, :me

    post "/accounts/:id/deposit", AccountsController, :deposit
    post "/accounts/:id/withdraw", AccountsController, :withdraw
    post "/accounts/transaction", AccountsController, :transaction
  end

  # coveralls-ignore-start
  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :rocketpay,
      swagger_file: "swagger.json"
  end

  # coveralls-ignore-stop

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      # coveralls-ignore-start
      live_dashboard "/dashboard", metrics: RocketpayWeb.Telemetry
      # coveralls-ignore-stop
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # coveralls-ignore-start
  def swagger_info do
    %{
      info: %{
        version: "1.0.0",
        title: "Rocketpay API",
        description: "API Documentation for Rocketpay v1",
        contact: %{
          name: "Wilton Souza",
          email: "willsouzafilho@gmail.com"
        }
      },
      tags: [
        %{name: "Users", description: "Operations about Users"},
        %{name: "Accounts", description: "Operations about Accounts"},
        %{name: "Authentication", description: "Operations about Authentication"}
      ]
    }
  end

  # coveralls-ignore-stop
end
