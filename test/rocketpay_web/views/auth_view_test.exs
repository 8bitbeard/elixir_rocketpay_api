defmodule RocketpayWeb.AuthViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory
  import Phoenix.View

  alias Rocketpay.User
  alias RocketpayWeb.Auth.Guardian
  alias RocketpayWeb.AuthView

  setup do
    params = build(:user_params)

    {:ok, %User{}} = Rocketpay.create_user(params)

    {:ok, email: params["email"], password: params["password"]}
  end

  test "renders login.json", %{email: email, password: password} do
    params = %{
      "email" => email,
      "password" => password
    }

    {:ok, token} = Guardian.authenticate(params)

    response = render(AuthView, "login.json", token: token)

    expected_response = %{
      message: "Authenticated successfully",
      token: token
    }

    assert expected_response == response
  end
end
