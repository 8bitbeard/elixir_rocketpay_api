defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory
  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = build(:user_from_params)

    token = "token123"

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    response = render(UsersView, "create.json", token: token, user: user)

    expected_response = %{
      message: "User created",
      token: token,
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "Machina From User",
        nickname: "machinafromuser"
      }
    }

    assert expected_response == response
  end
end
