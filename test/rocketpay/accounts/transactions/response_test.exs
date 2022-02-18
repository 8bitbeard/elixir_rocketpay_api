defmodule Rocketpay.Accounts.Transactions.ResponseTest do
  use Rocketpay.DataCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{Account, User}
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.Users.Create

  describe "build/2" do
    test "when all params are valid, returns an user" do
      from_params = build(:user_params)
      to_params = build(:user_params)

      {:ok, %User{account: %Account{} = from_account}} = Create.call(from_params)
      {:ok, %User{account: %Account{} = to_account}} = Create.call(to_params)

      response = TransactionResponse.build(from_account, to_account)

      assert %TransactionResponse{from_account: ^from_account, to_account: ^to_account} = response
    end
  end
end
