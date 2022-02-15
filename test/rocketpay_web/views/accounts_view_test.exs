defmodule RocketpayWeb.AccountsViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.AccountsView
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  test "renders update.json" do
    params = %{
      name: "Test User",
      password: "123456",
      nickname: "testuser",
      email: "testuser@example.com",
      age: 27
    }

    {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

    deposit_params = %{
      "id" => account_id,
      "value" => "2.00"
    }

    {:ok, %Account{balance: balance} = account} = Rocketpay.deposit(deposit_params)

    response = render(AccountsView, "update.json", account: account)

    expected_response = %{
      account: %{balance: balance, id: account_id},
      message: "Balance changed successfully"
    }

    assert expected_response == response
  end

  test "renders transaction.json" do
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

    {:ok, %User{account: %Account{id: from_account}}} = Rocketpay.create_user(from_params)
    {:ok, %User{account: %Account{id: to_account}}} = Rocketpay.create_user(to_params)

    deposit_params = %{
      "id" => from_account,
      "value" => "5.00"
    }

    {:ok, _result} = Rocketpay.deposit(deposit_params)

    transaction_params = %{
      "from" => from_account,
      "to" => to_account,
      "value" => "2.00"
    }

    {:ok,
     %TransactionResponse{
       from_account: %Account{id: from_account, balance: from_balance},
       to_account: %Account{id: to_account, balance: to_balance}
     } = transaction} = Rocketpay.transaction(transaction_params)

    response = render(AccountsView, "transaction.json", transaction: transaction)

    expected_response = %{
      message: "Transaction done successfully",
      transaction: %{
        from_account: %{balance: from_balance, id: from_account},
        to_account: %{balance: to_balance, id: to_account}
      }
    }

    assert expected_response == response
  end
end
