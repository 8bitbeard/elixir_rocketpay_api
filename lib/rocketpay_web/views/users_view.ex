defmodule RocketpayWeb.UsersView do
  use RocketpayWeb, :view

  alias Rocketpay.{Account, User}

  def render("create.json", %{
        token: token,
        user: %User{
          account: %Account{id: account_id, balance: balance},
          id: id,
          name: name,
          nickname: nickname
        }
      }) do
    %{
      message: "User created",
      token: token,
      user: %{
        id: id,
        name: name,
        nickname: nickname,
        account: %{
          id: account_id,
          balance: balance
        }
      }
    }
  end

  def render("user.json", %{
        user: %User{
          account: %Account{id: account_id, balance: balance},
          id: id,
          name: name,
          email: email,
          nickname: nickname
        }
      }) do
    %{
      user: %{
        id: id,
        name: name,
        nickname: nickname,
        email: email,
        account: %{
          id: account_id,
          balance: balance
        }
      }
    }
  end
end
