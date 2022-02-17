defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller
  use RocketpayWeb.Swagger.User

  alias Rocketpay.User
  alias RocketpayWeb.Auth.Guardian

  action_fallback RocketpayWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Rocketpay.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token, user: user)
    end
  end
end
