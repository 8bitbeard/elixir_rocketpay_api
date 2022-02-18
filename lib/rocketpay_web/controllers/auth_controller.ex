defmodule RocketpayWeb.AuthController do
  use RocketpayWeb, :controller
  use RocketpayWeb.Swagger.Auth

  alias Rocketpay.User
  alias RocketpayWeb.Auth.Guardian
  alias RocketpayWeb.FallbackController
  alias RocketpayWeb.UsersView

  action_fallback FallbackController

  def login(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:created)
      |> render("login.json", token: token)
    end
  end

  def me(conn, _params) do
    with %{"sub" => id} <- Guardian.Plug.current_claims(conn),
         {:ok, %User{} = user} <- Rocketpay.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> put_view(UsersView)
      |> render("user.json", user: user)
    end
  end
end
