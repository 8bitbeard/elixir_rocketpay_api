defmodule RocketpayWeb.AuthControllerTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{Account, User}

  setup %{conn: conn} do
    params = build(:user_params)

    {:ok, %User{account: %Account{}}} = Rocketpay.create_user(params)

    {:ok, conn: conn, email: params["email"], password: params["password"]}
  end

  describe "login/2" do
    test "when all params are valid, authenticate the user", %{
      conn: conn,
      email: email,
      password: password
    } do
      params = %{
        email: email,
        password: password
      }

      response =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:created)

      assert %{
               "message" => "Authenticated successfully",
               "token" => _token
             } = response
    end

    test "when trying to authenticate with an inexistent user, returns an error", %{conn: conn} do
      params = %{
        email: "inexistent@example.com",
        password: "123456"
      }

      response =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:unauthorized)

      expected_response = %{"message" => "Wrong e-mail or password!"}

      assert expected_response == response
    end

    test "when trying to authenticate with wrong password, returns an error", %{
      conn: conn,
      email: email
    } do
      params = %{
        email: email,
        password: "112233"
      }

      response =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:unauthorized)

      expected_response = %{"message" => "Wrong e-mail or password!"}

      assert expected_response == response
    end

    test "when not passing all the required parameters, returns an error", %{
      conn: conn,
      email: email
    } do
      params = %{
        email: email
      }

      response =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid or missing params"}

      assert expected_response == response
    end
  end

  describe "me/2" do
    test "when the token is valid, returns the logged user data", %{
      conn: conn,
      email: email,
      password: password
    } do
      params = %{
        email: email,
        password: password
      }

      %{"token" => token} =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:created)

      conn = put_req_header(conn, "authorization", "Bearer " <> token)

      response =
        conn
        |> get(Routes.auth_path(conn, :me))
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "email" => ^email
               }
             } = response
    end

    test "when the token is invalid, returns an error", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer invalid")

      response =
        conn
        |> get(Routes.auth_path(conn, :me))
        |> json_response(:unauthorized)

      expected_response = %{"message" => "invalid_token"}

      assert expected_response == response
    end

    test "when no token is informed, returns an unauthenticated error", %{conn: conn} do
      response =
        conn
        |> get(Routes.auth_path(conn, :me))
        |> json_response(:unauthorized)

      expected_response = %{"message" => "unauthenticated"}

      assert expected_response == response
    end
  end
end
