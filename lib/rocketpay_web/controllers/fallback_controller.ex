defmodule RocketpayWeb.FallbackController do
  use RocketpayWeb, :controller

  alias Rocketpay.Error
  alias RocketpayWeb.ErrorView

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
