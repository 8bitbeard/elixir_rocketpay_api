defmodule Rocketpay.Accounts.Transactions.ResponseTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Account, User}
  alias Rocketpay.Users.Create
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  describe "build/2" do
    test "when all params are valid, returns an user" do
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

      {:ok, %User{account: %Account{} = from_account}} = Create.call(from_params)
      {:ok, %User{account: %Account{} = to_account}} = Create.call(to_params)

      response = TransactionResponse.build(from_account, to_account)

      assert %TransactionResponse{from_account: ^from_account, to_account: ^to_account} = response
    end
  end
end
