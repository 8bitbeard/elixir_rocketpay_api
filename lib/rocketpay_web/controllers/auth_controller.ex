defmodule RocketpayWeb.AuthController do
  use RocketpayWeb, :controller

  alias RocketpayWeb.Auth.Guardian
  alias RocketpayWeb.FallbackController

  action_fallback FallbackController

  def login(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:created)
      |> render("login.json", token: token)
    end
  end
end
