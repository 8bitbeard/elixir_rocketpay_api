defmodule Rocketpay.Accounts.TransactionTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Account, Repo, User}
  alias Rocketpay.Users.Create
  alias Rocketpay.Accounts.{Deposit, Transaction}
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  describe "call/1" do
    setup do
      from_params = %{
        name: "From User",
        password: "123456",
        nickname: "fromuser",
        email: "fromuser@example.com",
        age: 27
      }

      to_params = %{
        name: "To User",
        password: "123456",
        nickname: "touser",
        email: "touser@example.com",
        age: 27
      }

      {:ok, %User{id: from_user_id, account: %Account{id: from_account_id}}} =
        Create.call(from_params)

      {:ok, %User{id: to_user_id, account: %Account{id: to_account_id}}} = Create.call(to_params)

      deposit_params = %{
        "id" => from_account_id,
        "value" => "5.00"
      }

      {:ok, _result} = Deposit.call(deposit_params)

      {:ok,
       from_user_id: from_user_id,
       from_account_id: from_account_id,
       to_user_id: to_user_id,
       to_account_id: to_account_id}
    end

    test "when all params are valid, returns an user", %{
      from_user_id: from_user_id,
      from_account_id: from_account_id,
      to_user_id: to_user_id,
      to_account_id: to_account_id
    } do
      transaction_params = %{
        "from" => from_account_id,
        "to" => to_account_id,
        "value" => "2.00"
      }

      {:ok,
       %TransactionResponse{
         from_account: %Account{balance: from_balance},
         to_account: %Account{balance: to_balance}
       }} = Transaction.call(transaction_params)

      from_account = Repo.get(Account, from_account_id)
      to_account = Repo.get(Account, to_account_id)

      assert %Account{id: ^from_account_id, balance: ^from_balance, user_id: ^from_user_id} =
               from_account

      assert %Account{id: ^to_account_id, balance: ^to_balance, user_id: ^to_user_id} = to_account
    end

    test "when there are invalid params, returns an error", %{
      from_account_id: from_account_id,
      to_account_id: to_account_id
    } do
      transaction_params = %{
        "from" => from_account_id,
        "to" => to_account_id,
        "value" => "banana"
      }

      {:error, result} = Transaction.call(transaction_params)

      expected_response = %Rocketpay.Error{
        result: "Invalid transaction value!",
        status: :bad_request
      }

      assert expected_response == result
    end
  end
end
