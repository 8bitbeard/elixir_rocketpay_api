defmodule Rocketpay.Accounts.WithdrawTest do
  use Rocketpay.DataCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{Account, Repo, User}
  alias Rocketpay.Users.Create
  alias Rocketpay.Accounts.{Deposit, Withdraw}

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = build(:user_params)

      {:ok, %User{id: user_id, account: %Account{id: account_id}}} = Create.call(params)

      deposit_params = %{
        "id" => account_id,
        "value" => "5.00"
      }

      {:ok, _result} = Deposit.call(deposit_params)

      withdraw_params = %{
        "id" => account_id,
        "value" => "2.00"
      }

      {:ok, %Account{}} = Withdraw.call(withdraw_params)

      expected_balance = Decimal.sub("5.00", "2.00")

      account = Repo.get(Account, account_id)

      assert %Account{id: ^account_id, balance: ^expected_balance, user_id: ^user_id} = account
    end

    test "when there are invalid params, returns an error" do
      params = build(:user_params)

      {:ok, %User{account: %Account{id: account_id}}} = Create.call(params)

      withdraw_params = %{
        "id" => account_id,
        "value" => "banana"
      }

      {:error, result} = Withdraw.call(withdraw_params)

      expected_response = %Rocketpay.Error{
        result: "Invalid transaction value!",
        status: :bad_request
      }

      assert expected_response == result
    end
  end
end
