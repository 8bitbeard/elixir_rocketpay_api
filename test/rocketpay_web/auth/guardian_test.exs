defmodule Rocketpay.GuardianTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory

  alias RocketpayWeb.Auth.Guardian

  alias Rocketpay.{Account, User}

  setup %{conn: conn} do
    params = build(:user_from_params)

    {:ok, %User{id: user_id, account: %Account{}} = user} = Rocketpay.create_user(params)

    {:ok,
     conn: conn,
     user: user,
     user_id: user_id,
     email: params["email"],
     password: params["password"]}
  end

  describe "subject_for_token/2" do
    test "returns the user id when a valid user is passed" do
      user = build(:user)

      response = Guardian.subject_for_token(user, "anything_goes")

      expected_response = {:ok, "3ad24a2c-ed8c-483f-86dc-0b607d4551ee"}

      assert expected_response == response
    end
  end

  describe "resource_from_claims/1" do
    test "resource_from_claims", %{user: user, user_id: user_id} do
      {:ok, _token, claims} = Guardian.encode_and_sign(user)

      response = Guardian.resource_from_claims(claims)

      assert {:ok, %User{id: ^user_id, name: "Machina From User"}} = response
    end
  end

  describe "authenticate/1" do
    test "when a valid email and password are given, returns a valid tuple with token", %{
      email: email,
      password: password
    } do
      params = %{
        "email" => email,
        "password" => password
      }

      response = Guardian.authenticate(params)

      assert {:ok, _token} = response
    end

    test "when wrong parameters are given, returns an error" do
      params = %{
        "email" => "invalid@example.com",
        "password" => "123456"
      }

      response = Guardian.authenticate(params)

      expected_response =
        {:error, %Rocketpay.Error{result: "Wrong e-mail or password!", status: :unauthorized}}

      assert expected_response == response
    end

    test "when a required parameter is not given, returns an error" do
      params = %{
        "email" => "invalid@example.com"
      }

      response = Guardian.authenticate(params)

      expected_response =
        {:error, %Rocketpay.Error{result: "Invalid or missing params", status: :bad_request}}

      assert expected_response == response
    end
  end
end
