defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory

  describe "create/2" do
    test "when all params are valid, create a user", %{conn: conn} do
      params = build(:user_params)
      name = params["name"]
      nickname = params["nickname"]

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created",
               "user" => %{
                 "account" => %{
                   "balance" => "0.00",
                   "id" => _account_id
                 },
                 "id" => _user_id,
                 "name" => ^name,
                 "nickname" => ^nickname
               }
             } = response
    end

    test "when the user password is smaller than 6 chars, returns an error", %{conn: conn} do
      params = build(:user_params, %{"password" => "12345"})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"password" => ["should be at least 6 character(s)"]}}

      assert response == expected_response
    end

    test "when the user email is invalid, returns an error", %{conn: conn} do
      params = build(:user_params, %{"email" => "invalid.com"})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"email" => ["has invalid format"]}}

      assert response == expected_response
    end

    test "when the user age is smaller than 18, returns an error", %{conn: conn} do
      params = build(:user_params, %{"age" => 17})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"age" => ["must be greater than or equal to 18"]}}

      assert response == expected_response
    end
  end
end
