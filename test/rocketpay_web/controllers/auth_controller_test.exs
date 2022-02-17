defmodule RocketpayWeb.AuthControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "login/2" do
    setup %{conn: conn} do
      params = %{
        name: "Test User",
        password: "123456",
        nickname: "testuser",
        email: "testuser@example.com",
        age: 27
      }

      {:ok, %User{account: %Account{}}} = Rocketpay.create_user(params)

      {:ok, conn: conn, email: params.email, password: params.password}
    end

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

    # test "when the user password is smaller than 6 chars, returns an error", %{conn: conn} do
    #   params = %{
    #     name: "Test User",
    #     password: "12345",
    #     nickname: "testuser",
    #     email: "testuser@example.com",
    #     age: 27
    #   }

    #   response =
    #     conn
    #     |> post(Routes.users_path(conn, :create, params))
    #     |> json_response(:bad_request)

    #   expected_response = %{"message" => %{"password" => ["should be at least 6 character(s)"]}}

    #   assert response == expected_response
    # end

    # test "when the user email is invalid, returns an error", %{conn: conn} do
    #   params = %{
    #     name: "Test User",
    #     password: "123456",
    #     nickname: "testuser",
    #     email: "testuserexample.com",
    #     age: 27
    #   }

    #   response =
    #     conn
    #     |> post(Routes.users_path(conn, :create, params))
    #     |> json_response(:bad_request)

    #   expected_response = %{"message" => %{"email" => ["has invalid format"]}}

    #   assert response == expected_response
    # end

    # test "when the user age is smaller than 18, returns an error", %{conn: conn} do
    #   params = %{
    #     name: "Test User",
    #     password: "123456",
    #     nickname: "testuser",
    #     email: "testuser@example.com",
    #     age: 17
    #   }

    #   response =
    #     conn
    #     |> post(Routes.users_path(conn, :create, params))
    #     |> json_response(:bad_request)

    #   expected_response = %{"message" => %{"age" => ["must be greater than or equal to 18"]}}

    #   assert response == expected_response
    # end
  end
end
