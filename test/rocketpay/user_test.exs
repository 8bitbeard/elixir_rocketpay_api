defmodule Rocketpay.UserTest do
  use Rocketpay.DataCase, async: true

  import Rocketpay.Factory

  alias Ecto.Changeset
  alias Rocketpay.User

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:user_from_params)

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "Machina From User"} = changes, valid?: true} = response
      assert Map.has_key?(changes, :password_hash)
    end

    test "when there are some error, returns an invalid changeset" do
      params =
        build(:user_from_params, %{"age" => 17, "password" => "12345", "email" => "invalid.com"})

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        email: ["has invalid format"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end

    test "when the required params are not given, returns an invalid changeset" do
      params = %{}

      response = User.changeset(params)

      expected_response = %{
        age: ["can't be blank"],
        email: ["can't be blank"],
        name: ["can't be blank"],
        nickname: ["can't be blank"],
        password: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
