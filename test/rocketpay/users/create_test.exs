defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{Error, Repo, User}
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = build(:user_from_params)

      {:ok, %User{id: user_id}} = Create.call(params)

      user = Repo.get(User, user_id)

      assert %User{name: "Machina From User", age: 30, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      params = build(:user_from_params, %{"age" => 15, "password" => nil})

      response = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert expected_response == errors_on(changeset)
    end
  end
end
