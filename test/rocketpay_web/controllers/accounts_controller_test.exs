defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.Auth.Guardian

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Test User",
        password: "123456",
        nickname: "testuser",
        email: "testuser@example.com",
        age: 27
      }

      {:ok, %User{account: %Account{id: account_id}} = user} = Rocketpay.create_user(params)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{
                 "balance" => "50.00",
                 "id" => _account_id
               },
               "message" => "Balance changed successfully"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid transaction value!"}

      assert response == expected_response
    end
  end

  describe "withdraw/2" do
    setup %{conn: conn} do
      params = %{
        name: "Test User",
        password: "123456",
        nickname: "testuser",
        email: "testuser@example.com",
        age: 27
      }

      {:ok, %User{account: %Account{id: account_id}} = user} = Rocketpay.create_user(params)

      deposit_params = %{"value" => "50.00"}

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, deposit_params))
      |> json_response(:ok)

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the withdraw", %{conn: conn, account_id: account_id} do
      withdraw_params = %{"value" => "25.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, withdraw_params))
        |> json_response(:ok)

      assert %{
               "account" => %{
                 "balance" => "25.00",
                 "id" => _account_id
               },
               "message" => "Balance changed successfully"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid transaction value!"}

      assert response == expected_response
    end
  end

  describe "transaction/2" do
    setup %{conn: conn} do
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

      {:ok, %User{account: %Account{id: from_account}} = user} = Rocketpay.create_user(from_params)
      {:ok, %User{account: %Account{id: to_account}}} = Rocketpay.create_user(to_params)

      deposit_params = %{"value" => "50.00"}

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn
      |> post(Routes.accounts_path(conn, :deposit, from_account, deposit_params))
      |> json_response(:ok)

      {:ok, conn: conn, from_account: from_account, to_account: to_account}
    end

    test "when all params are valid, make a transaction", %{
      conn: conn,
      from_account: from_account,
      to_account: to_account
    } do
      transaction_params = %{
        "from" => from_account,
        "to" => to_account,
        "value" => "15.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, transaction_params))
        |> json_response(:ok)

      expected_response = %{
        "message" => "Transaction done successfully",
        "transaction" => %{
          "from_account" => %{
            "balance" => "35.00",
            "id" => from_account
          },
          "to_account" => %{"balance" => "15.00", "id" => to_account}
        }
      }

      assert response == expected_response
    end

    test "when there are invalid params, returns an error", %{
      conn: conn,
      from_account: from_account,
      to_account: to_account
    } do
      transaction_params = %{
        "from" => from_account,
        "to" => to_account,
        "value" => "banana"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, transaction_params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid transaction value!"}

      assert response == expected_response
    end
  end
end
