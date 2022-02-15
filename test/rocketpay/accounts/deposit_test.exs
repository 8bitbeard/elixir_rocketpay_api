defmodule Rocketpay.Accounts.DepositTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Account, Repo, User}
  alias Rocketpay.Users.Create
  alias Rocketpay.Accounts.Deposit

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Test User",
        password: "123456",
        nickname: "testuser",
        email: "testuser@example.com",
        age: 27
      }

      {:ok, %User{id: user_id, account: %Account{id: account_id}}} = Create.call(params)

      deposit_params = %{
        "id" => account_id,
        "value" => "5.00"
      }

      {:ok, %Account{balance: balance}} = Deposit.call(deposit_params)

      account = Repo.get(Account, account_id)

      assert %Account{id: ^account_id, balance: ^balance, user_id: ^user_id} = account
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Test User",
        password: "123456",
        nickname: "testuser",
        email: "testuser@example.com",
        age: 27
      }

      {:ok, %User{account: %Account{id: account_id}}} = Create.call(params)

      deposit_params = %{
        "id" => account_id,
        "value" => "banana"
      }

      {:error, result} = Deposit.call(deposit_params)

      expected_response = "Invalid transaction value!"

      assert expected_response == result
    end
  end
end
