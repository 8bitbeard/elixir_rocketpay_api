defmodule Rocketpay.Users.GetTest do
  use Rocketpay.DataCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{Error, User}
  alias Rocketpay.Users.{Create, Get}

  describe "by_id/1" do
    test "when all params are valid, returns an user" do
      params = build(:user_from_params)

      {:ok, %User{id: user_id}} = Create.call(params)

      response = Get.by_id(user_id)

      assert {:ok, %User{name: "Machina From User", age: 30, id: ^user_id}} = response
    end

    test "when there are invalid params, returns an error" do
      user_id = "938a4732-ae56-4bcc-9b1b-25263c12f5df"

      response = Get.by_id(user_id)

      expected_response = {:error, %Error{result: "User not found", status: :not_found}}

      assert expected_response == response
    end
  end

  describe "by_email/1" do
    test "when all params are valid, returns an user" do
      params = build(:user_from_params)

      {:ok, %User{id: user_id, email: email}} = Create.call(params)

      response = Get.by_email(email)

      assert {:ok, %User{name: "Machina From User", age: 30, id: ^user_id}} = response
    end

    test "when there are invalid params, returns an error" do
      user_email = "inexistent@inexistent.com"

      response = Get.by_email(user_email)

      expected_response = {:error, %Error{result: "User not found", status: :not_found}}

      assert expected_response == response
    end
  end
end
