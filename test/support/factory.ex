defmodule Rocketpay.Factory do
  use ExMachina.Ecto, repo: Rocketpay.Ecto

  alias Faker.Person.PtBr
  alias Rocketpay.{Account, User}

  def user_params_factory do
    first_name = PtBr.first_name()
    last_name = PtBr.last_name()

    nickname =
      first_name
      |> String.downcase()
      |> String.replace(" ", "_")

    %{
      "age" => 30,
      "name" => "#{first_name} #{last_name}",
      "nickname" => nickname,
      "email" => "#{nickname}@example.com",
      "password" => "123456"
    }
  end

  def account_params_factory do
    %{
      user_id: Faker.UUID.v4(),
      balance: Decimal.new("5.00")
    }
  end

  def account_factory do
    %Account{
      id: Faker.UUID.v4(),
      balance: Decimal.new("0.00")
    }
  end

  def user_factory do
    first_name = PtBr.first_name()
    last_name = PtBr.last_name()

    nickname =
      first_name
      |> String.downcase()
      |> String.replace(" ", "_")

    %User{
      id: Faker.UUID.v4(),
      age: 30,
      name: "#{first_name} #{last_name}",
      nickname: nickname,
      email: "#{nickname}@example.com",
      password_hash: "password_hash",
      account: build(:account)
    }
  end
end
