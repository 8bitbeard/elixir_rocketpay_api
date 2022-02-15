defmodule RocketpayWeb.WelcomeControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "index/2" do
    test "when all params are valid, returns the welcome message", %{conn: conn} do
      filename = "numbers"

      response =
        conn
        |> get(Routes.welcome_path(conn, :index, filename))
        |> json_response(:ok)

      expected_response = %{"message" => "Welcome to Rocketpay API. Here is your number 37"}

      assert response == expected_response
    end

    test "when all params are invalid, returns an error", %{conn: conn} do
      filename = "inexistent"

      response =
        conn
        |> get(Routes.welcome_path(conn, :index, filename))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid file!"}

      assert response == expected_response
    end
  end
end
