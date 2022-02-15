defmodule Rocketpay.AccountTest do
  use Rocketpay.DataCase, async: true

  alias Ecto.Changeset
  alias Rocketpay.Account

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = %{
        balance: Decimal.new("5.00"),
        user_id: "a180d7c2-cf2d-45e9-a089-48bd26ae808d"
      }

      response = Account.changeset(params)

      assert %Changeset{changes: ^params, valid?: true} = response
    end

    test "when the balance is invalid, returns an invalid changeset" do
      params = %{
        balance: "invalid",
        user_id: "a180d7c2-cf2d-45e9-a089-48bd26ae808d"
      }

      response = Account.changeset(params)

      expected_response = %{balance: ["is invalid"]}

      assert errors_on(response) == expected_response
    end

    test "when the required params are not given, returns an invalid changeset" do
      params = %{}

      response = Account.changeset(params)

      expected_response = %{balance: ["can't be blank"], user_id: ["can't be blank"]}

      assert errors_on(response) == expected_response
    end
  end
end
