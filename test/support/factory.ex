defmodule Rocketpay.Factory do
  use ExMachina.Ecto, repo: Rocketpay.Ecto

  alias Rocketpay.{Account, User}

  def user_from_params_factory do
    %{
      "age" => 30,
      "name" => "Machina From User",
      "nickname" => "machinafromuser",
      "email" => "machinafromuser@example.com",
      "password" => "123456"
    }
  end

  def user_to_params_factory do
    %{
      "age" => 30,
      "name" => "Machina To User",
      "nickname" => "machinauser",
      "email" => "machinatouser@example.com",
      "password" => "123456"
    }
  end

  def account_params_factory do
    %{
      user_id: "4ad79fce-0e4e-4cb9-b2cc-a1938f4c508f",
      balance: Decimal.new("5.00")
    }
  end

  def account_factory do
    %Account{
      id: "7f94f559-5666-4511-982b-db78f4babc73",
      balance: Decimal.new("0.00")
    }
  end

  def account_two_factory do
    %Account{
      id: "00f2e5ea-652c-444b-8ea0-850a1db2afeb",
      balance: Decimal.new("0.00")
    }
  end

  def user_factory do
    %User{
      id: "3ad24a2c-ed8c-483f-86dc-0b607d4551ee",
      age: 30,
      name: "Machina User",
      nickname: "machinauser",
      email: "machinauser@example.com",
      password_hash: "password_hash",
      account: build(:account)
    }
  end

  def user_two_factory do
    %User{
      id: "c8ffb299-4d65-48c4-8d81-2137ed643464",
      age: 30,
      name: "Machina User",
      nickname: "machinauser",
      email: "machinauser@example.com",
      password: "123456",
      account: build(:account)
    }
  end
end
