defmodule Rocketpay.Accounts.OperationTest do
  use Rocketpay.DataCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{Account, Repo, User}
  alias Rocketpay.Users.Create
  alias Rocketpay.Accounts.{Deposit, Operation}

  describe "call/2" do
    test "when the operation is deposit, performs a deposit successully" do
      params = build(:user_params)

      {:ok, %User{id: user_id, account: %Account{id: account_id}}} = Create.call(params)

      deposit_params = %{
        "id" => account_id,
        "value" => "5.00"
      }

      response =
        deposit_params
        |> Operation.call(:deposit)
        |> Repo.transaction()

      assert {:ok,
              %{
                account_deposit: %Account{
                  id: ^account_id,
                  user_id: ^user_id
                },
                deposit: %Account{
                  id: ^account_id,
                  user_id: ^user_id
                }
              }} = response
    end

    test "when the operation is withdraw, performs a withdraw successully" do
      params = build(:user_params)

      {:ok, %User{id: user_id, account: %Account{id: account_id}}} = Create.call(params)

      deposit_params = %{
        "id" => account_id,
        "value" => "5.00"
      }

      {:ok, %Account{}} = Deposit.call(deposit_params)

      withdraw_params = %{
        "id" => account_id,
        "value" => "2.00"
      }

      response =
        withdraw_params
        |> Operation.call(:withdraw)
        |> Repo.transaction()

      assert {:ok,
              %{
                account_withdraw: %Account{
                  id: ^account_id,
                  user_id: ^user_id
                },
                withdraw: %Account{
                  id: ^account_id,
                  user_id: ^user_id
                }
              }} = response
    end

    test "returns an error when the operation is invalid" do
      params = build(:user_params)

      {:ok, %User{account: %Account{id: account_id}}} = Create.call(params)

      params = %{
        "id" => account_id,
        "value" => "2.00"
      }

      response =
        params
        |> Operation.call(:invalid)
        |> Repo.transaction()

      assert {:error, :invalid,
              %Rocketpay.Error{result: "Invalid operation!", status: :bad_request},
              %{account_invalid: _value}} = response
    end

    test "returns an error when the account does not exists" do
      deposit_params = %{
        "id" => "a180d7c2-cf2d-45e9-a089-48bd26ae808d",
        "value" => "5.00"
      }

      response =
        deposit_params
        |> Operation.call(:deposit)
        |> Repo.transaction()

      expected_response = {:error, :account_deposit, "Account not found!", %{}}

      assert expected_response == response
    end

    test "returns an error when the value is invalid" do
      params = build(:user_params)

      {:ok, %User{account: %Account{id: account_id}}} = Create.call(params)

      deposit_params = %{
        "id" => account_id,
        "value" => "banana"
      }

      response =
        deposit_params
        |> Operation.call(:deposit)
        |> Repo.transaction()

      assert {:error, :deposit,
              %Rocketpay.Error{result: "Invalid transaction value!", status: :bad_request},
              %{account_deposit: _value}} = response
    end
  end
end
