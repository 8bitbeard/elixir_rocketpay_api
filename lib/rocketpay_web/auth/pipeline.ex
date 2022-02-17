defmodule RocketpayWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :rocketpay

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
